package com.scanner.document_scanner.fallback.utils

import android.graphics.Bitmap
import com.scanner.document_scanner.fallback.models.Point
import kotlin.math.abs
import kotlin.math.sqrt

/**
 * Auto-capture detector for document scanning
 * Determines if a document is stable and well-aligned for automatic capture
 */
class AutoCaptureDetector {
    private val detectionHistory = mutableListOf<DetectionResult>()
    private val maxHistorySize = 5
    private val stabilityThreshold = 0.95 // 95% similarity required
    private val minAreaThreshold = 0.15 // Document must cover at least 15% of frame

    data class DetectionResult(
        val corners: List<Point>?,
        val area: Double,
        val timestamp: Long
    )

    /**
     * Check if the document is ready for auto-capture
     *
     * @param corners The detected document corners (or null if not detected)
     * @param frameWidth The camera frame width
     * @param frameHeight The camera frame height
     * @return true if document is stable and ready for capture
     */
    fun isReadyForCapture(corners: List<Point>?, frameWidth: Int, frameHeight: Int): Boolean {
        val frameArea = frameWidth.toDouble() * frameHeight.toDouble()
        val documentArea = corners?.let { calculateQuadArea(it) } ?: 0.0
        val areaRatio = documentArea / frameArea

        // Add current detection to history
        val result = DetectionResult(
            corners = corners,
            area = areaRatio,
            timestamp = System.currentTimeMillis()
        )

        detectionHistory.add(result)

        // Keep only recent history
        if (detectionHistory.size > maxHistorySize) {
            detectionHistory.removeAt(0)
        }

        // Need enough history to determine stability
        if (detectionHistory.size < maxHistorySize) {
            return false
        }

        // Check if document is detected in all recent frames
        if (detectionHistory.any { it.corners == null }) {
            return false
        }

        // Check if document covers enough of the frame
        if (areaRatio < minAreaThreshold) {
            return false
        }

        // Check if document position is stable
        return isStable()
    }

    /**
     * Check if document position is stable across recent detections
     */
    private fun isStable(): Boolean {
        if (detectionHistory.size < 2) return false

        val reference = detectionHistory.first()

        for (i in 1 until detectionHistory.size) {
            val current = detectionHistory[i]

            if (reference.corners == null || current.corners == null) {
                return false
            }

            // Calculate similarity between reference and current
            val similarity = calculateSimilarity(reference.corners, current.corners)

            if (similarity < stabilityThreshold) {
                return false
            }
        }

        return true
    }

    /**
     * Calculate similarity between two sets of corners (0.0 to 1.0)
     */
    private fun calculateSimilarity(corners1: List<Point>, corners2: List<Point>): Double {
        if (corners1.size != 4 || corners2.size != 4) return 0.0

        var totalDistance = 0.0
        var maxPossibleDistance = 0.0

        for (i in 0 until 4) {
            val p1 = corners1[i]
            val p2 = corners2[i]

            val distance = distance(p1, p2)
            totalDistance += distance

            // Estimate max possible distance (diagonal of a large frame)
            maxPossibleDistance += 1000.0
        }

        // Convert distance to similarity (closer = more similar)
        return 1.0 - (totalDistance / maxPossibleDistance).coerceIn(0.0, 1.0)
    }

    /**
     * Calculate Euclidean distance between two points
     */
    private fun distance(p1: Point, p2: Point): Double {
        val dx = p1.x - p2.x
        val dy = p1.y - p2.y
        return sqrt(dx * dx + dy * dy)
    }

    /**
     * Calculate the area of a quadrilateral using the Shoelace formula
     */
    private fun calculateQuadArea(corners: List<Point>): Double {
        if (corners.size != 4) return 0.0

        // Shoelace formula for polygon area
        var sum1 = 0.0
        var sum2 = 0.0

        for (i in corners.indices) {
            val j = (i + 1) % corners.size
            sum1 += corners[i].x * corners[j].y
            sum2 += corners[j].x * corners[i].y
        }

        return abs(sum1 - sum2) / 2.0
    }

    /**
     * Reset the detection history
     */
    fun reset() {
        detectionHistory.clear()
    }
}
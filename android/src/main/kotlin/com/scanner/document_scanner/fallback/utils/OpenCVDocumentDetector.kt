package com.scanner.document_scanner.fallback.utils

import android.graphics.Bitmap
import com.scanner.document_scanner.fallback.models.Point
import org.opencv.android.Utils
import org.opencv.core.*
import org.opencv.imgproc.Imgproc
import kotlin.math.sqrt

/**
 * OpenCV-based document corner detector
 */
class OpenCVDocumentDetector {

    /**
     * Detect document corners in a bitmap image
     *
     * @param bitmap the input image
     * @return List of 4 corner points (topLeft, topRight, bottomLeft, bottomRight) or null if detection fails
     */
    fun detectCorners(bitmap: Bitmap): List<Point>? {
        try {
            // Convert bitmap to OpenCV Mat
            val originalMat = Mat()
            Utils.bitmapToMat(bitmap, originalMat)

            // Convert to grayscale
            val grayMat = Mat()
            Imgproc.cvtColor(originalMat, grayMat, Imgproc.COLOR_RGB2GRAY)

            // Apply Gaussian blur to reduce noise
            val blurredMat = Mat()
            Imgproc.GaussianBlur(grayMat, blurredMat, Size(5.0, 5.0), 0.0)

            // Apply Canny edge detection
            val edgesMat = Mat()
            Imgproc.Canny(blurredMat, edgesMat, 75.0, 200.0)

            // Dilate edges to close gaps
            val dilatedMat = Mat()
            val kernel = Imgproc.getStructuringElement(Imgproc.MORPH_RECT, Size(5.0, 5.0))
            Imgproc.dilate(edgesMat, dilatedMat, kernel)

            // Find contours
            val contours = mutableListOf<MatOfPoint>()
            val hierarchy = Mat()
            Imgproc.findContours(
                dilatedMat,
                contours,
                hierarchy,
                Imgproc.RETR_EXTERNAL,
                Imgproc.CHAIN_APPROX_SIMPLE
            )

            // Sort contours by area (descending)
            contours.sortByDescending { Imgproc.contourArea(it) }

            // Find the largest contour that approximates to a quadrilateral
            for (contour in contours) {
                val contourArea = Imgproc.contourArea(contour)
                val imageArea = (originalMat.rows() * originalMat.cols()).toDouble()

                // Skip if contour is too small (less than 10% of image area)
                if (contourArea < imageArea * 0.1) {
                    continue
                }

                // Approximate contour to polygon
                val contour2f = MatOfPoint2f(*contour.toArray())
                val peri = Imgproc.arcLength(contour2f, true)
                val approx = MatOfPoint2f()
                Imgproc.approxPolyDP(contour2f, approx, 0.02 * peri, true)

                // Check if we found a quadrilateral
                if (approx.rows() == 4) {
                    val points = approx.toArray()

                    // Order points: top-left, top-right, bottom-left, bottom-right
                    val orderedPoints = orderPoints(points)

                    // Release resources
                    originalMat.release()
                    grayMat.release()
                    blurredMat.release()
                    edgesMat.release()
                    dilatedMat.release()
                    kernel.release()
                    hierarchy.release()
                    contour2f.release()
                    approx.release()

                    return orderedPoints.map { Point(it.x, it.y) }
                }

                contour2f.release()
            }

            // Release resources if no quadrilateral found
            originalMat.release()
            grayMat.release()
            blurredMat.release()
            edgesMat.release()
            dilatedMat.release()
            kernel.release()
            hierarchy.release()

            return null
        } catch (e: Exception) {
            e.printStackTrace()
            return null
        }
    }

    /**
     * Order points in the following order: top-left, top-right, bottom-left, bottom-right
     *
     * @param points array of 4 OpenCV points
     * @return ordered array of points
     */
    private fun orderPoints(points: Array<org.opencv.core.Point>): Array<org.opencv.core.Point> {
        // Sort by y-coordinate
        val sortedByY = points.sortedBy { it.y }

        // Get top two points (smaller y values)
        val topPoints = sortedByY.take(2).sortedBy { it.x }
        val topLeft = topPoints[0]
        val topRight = topPoints[1]

        // Get bottom two points (larger y values)
        val bottomPoints = sortedByY.takeLast(2).sortedBy { it.x }
        val bottomLeft = bottomPoints[0]
        val bottomRight = bottomPoints[1]

        return arrayOf(topLeft, topRight, bottomLeft, bottomRight)
    }

    /**
     * Calculate distance between two points
     */
    private fun distance(p1: org.opencv.core.Point, p2: org.opencv.core.Point): Double {
        val dx = p1.x - p2.x
        val dy = p1.y - p2.y
        return sqrt(dx * dx + dy * dy)
    }
}
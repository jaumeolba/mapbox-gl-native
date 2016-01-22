package com.mapbox.mapboxsdk.camera;

import android.graphics.Point;
import android.support.annotation.NonNull;

import com.mapbox.mapboxsdk.geometry.LatLng;
import com.mapbox.mapboxsdk.geometry.LatLngBounds;

public class CameraUpdateFactory {

    /**
     * Returns a CameraUpdate that moves the camera to a specified CameraPosition.
     * @param cameraPosition Camera Position to change to
     * @return CameraUpdate Final Camera Position data
     */
    public static CameraUpdate newCameraPosition (@NonNull CameraPosition cameraPosition) {
        return new CameraUpdate(cameraPosition.bearing, cameraPosition.target, cameraPosition.tilt, cameraPosition.zoom);
    }

    /**
     * Returns a CameraUpdate that moves the center of the screen to a latitude and longitude
     * specified by a LatLng object. This centers the camera on the LatLng object.
     *
     * @param latLng
     * @return
     */
    public static CameraUpdate newLatLng(@NonNull LatLng latLng){
        throw new UnsupportedOperationException("Not implemented yet");
    }

    /**
     * Returns a CameraUpdate that transforms the camera such that the specified latitude/longitude
     * bounds are centered on screen at the greatest possible zoom level.
     * You can specify padding, in order to inset the bounding box from the map view's edges.
     * The returned CameraUpdate has a bearing of 0 and a tilt of 0.
     *
     * @param bounds
     * @param padding
     * @return
     */
    public static CameraUpdate newLatLngBounds(@NonNull LatLngBounds bounds, int padding){
        throw new UnsupportedOperationException("Not implemented yet");
    }

    /**
     * Returns a CameraUpdate that transforms the camera such that the specified latitude/longitude
     * bounds are centered on screen within a bounding box of specified dimensions at the greatest
     * possible zoom level. You can specify additional padding, to further restrict the size of
     * the bounding box. The returned CameraUpdate has a bearing of 0 and a tilt of 0.
     *
     * @param bounds
     * @param width
     * @param height
     * @param padding
     * @return
     */
    public static CameraUpdate newLatLngBounds(@NonNull LatLngBounds bounds, int width, int height, int padding){
        throw new UnsupportedOperationException("Not implemented yet");
    }

    /**
     * Returns a CameraUpdate that moves the center of the screen to a latitude and longitude specified by a LatLng object, and moves to the given zoom level.
     *
     * @param latLng
     * @param zoom
     * @return
     */
    public static CameraUpdate newLatLngZoom(@NonNull LatLng latLng, float zoom){
        throw new UnsupportedOperationException("Not implemented yet");
    }

    /**
     * Returns a CameraUpdate that scrolls the camera over the map, shifting the center of view by the specified number of pixels in the x and y directions.
     *
     * @param xPixel
     * @param yPixel
     * @return
     */
    public static CameraUpdate scrollBy(float xPixel, float yPixel){
        throw new UnsupportedOperationException("Not implemented yet");
    }

    /**
     * Returns a CameraUpdate that shifts the zoom level of the current camera viewpoint.
     *
     * @param amount
     * @param focus
     * @return
     */
    public static CameraUpdate zoomBy(float amount, Point focus){
        throw new UnsupportedOperationException("Not implemented yet");
    }

    /**
     * Returns a CameraUpdate that shifts the zoom level of the current camera viewpoint.
     *
     * @param amount
     * @return
     */
    public static CameraUpdate zoomBy(float amount){
        throw new UnsupportedOperationException("Not implemented yet");
    }

    /**
     * Returns a CameraUpdate that zooms in on the map by moving the viewpoint's height closer to the Earth's surface. The zoom increment is 1.0.
     *
     * @return
     */
    public static CameraUpdate zoomIn(){
        throw new UnsupportedOperationException("Not implemented yet");
    }

    /**
     * Returns a CameraUpdate that zooms out on the map by moving the viewpoint's height farther away from the Earth's surface. The zoom increment is -1.0.
     *
     * @return
     */
    public static CameraUpdate zoomOut(){
        throw new UnsupportedOperationException("Not implemented yet");
    }

    /**
     * Returns a CameraUpdate that moves the camera viewpoint to a particular zoom level.
     *
     * @param zoom
     * @return
     */
    public static CameraUpdate zoomTo(float zoom){
        throw new UnsupportedOperationException("Not implemented yet");
    }

}

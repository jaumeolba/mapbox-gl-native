import com.mapbox.mapboxsdk.maps.MapView;
import com.mapbox.mapboxsdk.maps.MapboxMap;

import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;

import static org.junit.Assert.assertNotNull;

public class MapboxMapTest {

    private MapboxMap mMapboxMap;

    @Before
    public void beforeTest() {
        mMapboxMap = new MapboxMap(mock(MapView.class));
    }

    @Test
    public void testSanity() {
        assertNotNull("mMapboxMap should not be null", mMapboxMap);
    }

    @Test
    public void testCompassEnabled() {
        mMapboxMap.setCompassEnabled(true);
        assertTrue("CompassEnabled should be true", mMapboxMap.isCompassEnabled());
    }

    @Test
    public void testCompassDisabled() {
        mMapboxMap.setCompassEnabled(false);
        assertFalse("CompassbEnabled should be false", mMapboxMap.isCompassEnabled());
    }

    @Test
    public void testScrollEnabled() {
        mMapboxMap.setScrollEnabled(true);
        assertTrue("ScrollEnabled should be true", mMapboxMap.isScrollEnabled());
    }

    @Test
    public void testScrollDisabled() {
        mMapboxMap.setScrollEnabled(false);
        assertFalse("ScrollEnabled should be false", mMapboxMap.isScrollEnabled());
    }

    @Test
    public void testRotateEnabled() {
        mMapboxMap.setRotateEnabled(true);
        assertTrue("RotateEnabled should be true", mMapboxMap.isRotateEnabled());
    }

    @Test
    public void testRotateDisabled() {
        mMapboxMap.setRotateEnabled(false);
        assertFalse("RotateDisabled should be false", mMapboxMap.isRotateEnabled());
    }

    @Test
    public void testZoomEnabled() {
        mMapboxMap.setZoomEnabled(true);
        assertTrue("ZoomEnabled should be true", mMapboxMap.isZoomEnabled());
    }

    @Test
    public void testZoomDisabled() {
        mMapboxMap.setZoomEnabled(false);
        assertFalse("ZoomEnabled should be false", mMapboxMap.isZoomEnabled());
    }

    @Test
    public void testZoomControlsEnabled() {
        mMapboxMap.setZoomControlsEnabled(true);
        assertTrue("ZoomControlsEnabled should be true", mMapboxMap.isZoomControlsEnabled());
    }

    @Test
    public void testZoomControlsDisabled() {
        mMapboxMap.setZoomControlsEnabled(false);
        assertFalse("ZoomControlsEnabled should be false", mMapboxMap.isZoomControlsEnabled());
    }

    @Test
    public void testTiltEnabled() {
        mMapboxMap.setTiltEnabled(true);
        assertTrue("TiltEnabled should be true", mMapboxMap.isTiltEnabled());
    }

    @Test
    public void testTiltDisabled() {
        mMapboxMap.setTiltEnabled(false);
        assertFalse("TiltEnabled should be false", mMapboxMap.isTiltEnabled());
    }

    @Test
    public void testConcurrentInfoWindowEnabled() {
        mMapboxMap.setAllowConcurrentMultipleOpenInfoWindows(true);
        assertTrue("ConcurrentWindows should be true", mMapboxMap.isAllowConcurrentMultipleOpenInfoWindows());
    }

    @Test
    public void testConcurrentInfoWindowDisabled() {
        mMapboxMap.setAllowConcurrentMultipleOpenInfoWindows(false);
        assertFalse("ConcurretnWindows should be false", mMapboxMap.isAllowConcurrentMultipleOpenInfoWindows());
    }

}

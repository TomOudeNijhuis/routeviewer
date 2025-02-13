import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import 'leaflet-gpx';

export default defineNuxtPlugin(() => {
  return {
    provide: {
      leaflet: L
    }
  };
});

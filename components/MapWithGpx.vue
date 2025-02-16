<template>
    <div ref="mapContainer" style="width: 100%; height: 100%;"></div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useNuxtApp } from '#app';

const mapContainer = ref(null);
const { $leaflet: L } = useNuxtApp();

var taIcon = L.icon({
    iconUrl: 'ta.png',
    shadowUrl: null,

    iconSize: [46, 40],
    shadowSize: null,
    iconAnchor: [23, 20],
    shadowAnchor: null,
    popupAnchor: [0, -25]
});

var cpIcon = L.icon({
    iconUrl: 'cp.png',
    shadowUrl: null,

    iconSize: [40, 40],
    shadowSize: null,
    iconAnchor: [20, 20],
    shadowAnchor: null,
    popupAnchor: [0, -25]
});

const gpxUrlList = ['1.gpx','2.gpx','3.gpx','4.gpx','5.gpx','6.gpx','7.gpx','8.gpx'];
const colors = ['#0000FF', '#FFFF00', '#FF00FF', '#00FFFF', '#FFA500', '#800080', '#008000', '#000000'];
const checkPoints = [
    { lat: 52.222233, lon: 7.805282, name: 'CP01'},
    { lat: 52.224454, lon: 7.813146, name: 'CP02' },
    { lat: 52.219186, lon: 7.821847, name: 'CP03' },
    { lat: 52.220005, lon: 7.812918, name: 'CP04' },
    { lat: 52.217614, lon: 7.803174, name: 'CP10' },
    { lat: 52.224592, lon: 7.773718, name: 'CP11' },
    { lat: 52.235783, lon: 7.751091, name: 'CP12' },
    { lat: 52.234883, lon: 7.734413, name: 'CP13' },
    { lat: 52.244281, lon: 7.702210, name: 'CP14' },
    { lat: 52.255773, lon: 7.679797, name: 'CP20' },
    { lat: 52.286597, lon: 7.622644, name: 'CP21', hint: 'Brug' },
    { lat: 52.256888, lon: 7.600318, name: 'CP22', hint: 'Bankje'},
    { lat: 52.250914, lon: 7.561029, name: 'CP23'},
    { lat: 52.229205, lon: 7.535093, name: 'CP24'},
    { lat: 52.24348, lon: 7.49757, name: 'CP25' },
    { lat: 52.230461, lon: 7.463783, name: 'CP26', hint: 'Hek' },
    { lat: 52.256134, lon: 7.441456, name: 'CP27' },
    { lat: 52.316879, lon: 7.422256, name: 'CP30', hint: 'Bordje Naturschutzgebiet'},
    { lat: 52.370295, lon: 7.354635, name: 'CP31', hint: 'Fur jeden Burger des Emslandes ein Baum'},
    { lat: 52.328121, lon: 7.355696, name: 'CP32', hint: 'Bankje onder overkapping'},
    { lat: 52.280999, lon: 7.317416, name: 'CP33', hint: 'Grenspaal'},
    { lat: 52.274929, lon: 7.207907, name: 'CP34', hint: 'Kruising'},
    { lat: 52.292696, lon: 7.235394, name: 'CP35', hint: 'Boom bij water'},


]

const loadMap = () => {
    if (!mapContainer.value || !L) return;

    const map = L.map(mapContainer.value).setView([52.3676, 4.9041], 12);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: 'TAR',
    }).addTo(map);

    L.control.scale({ position: 'topright' }).addTo(map);

    let loadedCount = 0;
    const bounds = L.latLngBounds();

    gpxUrlList.forEach((gpxUrl, index) => {
        new L.GPX(gpxUrl, {
            async: true,
            polyline_options: {
                color: colors[index % colors.length],
            },
            markers: {
                startIcon: null,
                endIcon: null,
            },
        })
        .on('loaded', function (e) {
            bounds.extend(e.target.getBounds());
            loadedCount++;
            if (loadedCount === gpxUrlList.length) {
                map.fitBounds(bounds);
            }
        })
        .addTo(map);
    });

    const taMarkers = [
        L.marker([52.219627, 7.809509], { icon: taIcon }).bindPopup("Start/TA1"),
        L.marker([52.246669, 7.695376], { icon: taIcon }).bindPopup("TA2"),
        L.marker([52.272563, 7.451520], { icon: taIcon }).bindPopup("TA3"),
        L.marker([52.302476, 7.178782], { icon: taIcon }).bindPopup("TA4"),
        L.marker([52.310017, 7.024850], { icon: taIcon }).bindPopup("TA5"),
        L.marker([52.258945, 7.015103], { icon: taIcon }).bindPopup("TA6"),
        L.marker([52.259490, 7.003328], { icon: taIcon }).bindPopup("Finish"),
    ];

    taMarkers.forEach(marker => marker.addTo(map));
    
    const cpMarkers = [];
    checkPoints.forEach(cp => {
        const popupContent = `
            <strong>${cp.name}</strong><br>
            ${cp.hint ? 'hint: ' + cp.hint + '<br>' : ''}
            <br>
            <a href="https://www.google.com/maps?q=${cp.lat},${cp.lon}" target="_blank">Bekijk in Google Maps</a>
        `;
        cpMarkers.push(
            L.marker([cp.lat, cp.lon], { icon: cpIcon }).bindPopup(popupContent)
        );
    });

    const updateMarkerVisibility = () => {
        const zoomLevel = map.getZoom();
        cpMarkers.forEach(marker => {
            if (zoomLevel >= 13) {
                marker.addTo(map);
            } else {
                map.removeLayer(marker);
            }
        });
    };

    map.on('zoomend', updateMarkerVisibility);
    updateMarkerVisibility();
};

onMounted(() => {
    loadMap();
});
</script>
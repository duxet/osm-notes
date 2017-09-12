<template>
  <div style="height: 100%">
    <v-map :zoom=13 :center="[47.413220, -1.219482]">
      <v-tilelayer url="http://{s}.tile.osm.org/{z}/{x}/{y}.png"></v-tilelayer>
      <v-marker :lat-lng="[47.413220, -1.219482]"></v-marker>
    </v-map>
  </div>
</template>

<script>
import L from 'leaflet'

export default {
  
}
</script>

<style lang="scss">
    @import "~bulma/sass/utilities/_all";

    // Customization goes here

    @import "~bulma";
    @import "~buefy/src/scss/buefy";
    @import "~leaflet/dist/leaflet.css";
</style>

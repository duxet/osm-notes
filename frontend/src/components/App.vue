<template>
  <div>
    <nav id="app-navbar" class="navbar" role="navigation" aria-label="main navigation">
      <div class="navbar-brand">
        <a class="navbar-item" href="http://bulma.io">
          <img src="http://bulma.io/images/bulma-logo.png" alt="Bulma: a modern CSS framework based on Flexbox" width="112" height="28">
        </a>
      </div>
    </nav>

    <div id="app-container" class="columns is-gapless">
      <div class="column is-one-third">
        <note-list :notes="notes" />
      </div>
      <div class="column">
        <v-map :zoom=1 :center="[0, 0]">
          <v-tilelayer url="http://{s}.tile.osm.org/{z}/{x}/{y}.png"></v-tilelayer>
          <v-marker v-for="note in notes" :key="note.id" :lat-lng="[note.location.latitude, note.location.longitude]"></v-marker>
        </v-map>
      </div>
    </div>
  </div>
</template>

<script>
import Axios from 'axios'
import L from 'leaflet'

import NoteList from './Note/NoteList'

export default {
  components: {
    'note-list': NoteList
  },
  data: function () {
    return {
      notes: []
    }
  },
  mounted: function () {
    this.loadNotes()
  },
  methods: {
    loadNotes: function () {
      Axios.get('http://localhost:8080/notes').then((response) => {
        this.notes = response.data
      })
    }
  }
}
</script>

<style lang="scss">
    @import "~bulma/sass/utilities/_all";

    // Customization goes here

    @import "~bulma";
    @import "~buefy/src/scss/buefy";
    @import "~leaflet/dist/leaflet.css";

    #app-navbar {
      width: 100%;
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
    }

    #app-container {
      height: 100vh;
      padding-top: 3.25rem;
    }
</style>

<template>
  <div style="padding: 20px; height: 100%; overflow-y: scroll">
    <note v-for="note in notes" :key="note.id" :note="note" />
  </div>
</template>

<script>
import Note from './Note'

export default {
  components: {
    'note': Note
  },
  props: ['notes']
}
</script>

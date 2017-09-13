<template>
  <article class="media">
    <div class="media-content">
      <div class="content">
        <p>
          <strong>Note #{{ note.id }}</strong>
          <br> {{ note.comments[0].text }}
          <br>
          <small>
            <a>Like</a> ·
            <a>Reply</a> · 3 hrs</small>
        </p>
      </div>
    </div>
  </article>
</template>

<script>
export default {
  props: ['note']
}
</script>


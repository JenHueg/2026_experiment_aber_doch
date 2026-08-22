# BreakPage.vue

```vue
<template>
  <div class="page">
    <h1>Pause</h1>

    <p>
      Sie haben den ersten Teil des Experiments abgeschlossen.
    </p>

    <p>
      Machen Sie gerne eine kurze Pause.
    </p>

    <button @click="$emit('continue')">
      Mit dem zweiten Block fortfahren
    </button>
  </div>
</template>

<style scoped>
.page {
  max-width: 700px;
  margin: 60px auto;
  text-align: center;
  font-family: Arial, sans-serif;
}

button {
  margin-top: 30px;
  padding: 12px 28px;
  font-size: 18px;
}
</style>
```

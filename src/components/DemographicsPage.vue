# DemographicsPage.vue

```vue
<template>
  <div class="page">

    <h1>Freiwillige Angaben</h1>

    <p>
      Die folgenden Angaben sind freiwillig und dienen ausschließlich wissenschaftlichen Zwecken.
    </p>

    <div class="form-group">
      <label>Alter</label>
      <input
        type="number"
        v-model="age"
        min="18"
        max="120"
      >
    </div>

    <div class="form-group">
      <label>Geschlecht</label>

      <select v-model="gender">
        <option value="">Keine Angabe</option>
        <option value="weiblich">weiblich</option>
        <option value="männlich">männlich</option>
        <option value="divers">divers</option>
        <option value="selbstbeschreibung">Selbstbeschreibung</option>
      </select>

      <input
        v-if="gender === 'selbstbeschreibung'"
        type="text"
        v-model="genderSelfDescription"
        placeholder="Bitte angeben"
      >
    </div>

    <div class="form-group">
      <label>Muttersprache</label>
      <input
        type="text"
        v-model="nativeLanguage"
        placeholder="z. B. Deutsch"
      >
    </div>

    <button @click="submit">
      Weiter
    </button>

  </div>
</template>

<script>
export default {

  data() {
    return {
      age: '',
      gender: '',
      genderSelfDescription: '',
      nativeLanguage: ''
    }
  },

  methods: {

    submit() {

      this.$emit('finished', {

        age: this.age,

        gender: this.gender,

        genderSelfDescription:
          this.genderSelfDescription,

        nativeLanguage:
          this.nativeLanguage

      })

    }

  }

}
</script>

<style scoped>
.page {
  max-width: 700px;
  margin: 60px auto;
  font-family: Arial, sans-serif;
}

.form-group {
  margin-bottom: 25px;
}

label {
  display: block;
  margin-bottom: 8px;
  font-weight: bold;
}

input,
select {
  width: 100%;
  padding: 10px;
  font-size: 16px;
}

button {
  margin-top: 20px;
  padding: 12px 28px;
  font-size: 18px;
}
</style>
```


<template>
  <div class="page">
    <h2>Das Experiment beginnt</h2>

    <p>
      Vielen Dank! Sie haben den Übungsteil abgeschlossen.
    </p>

    <p>
      Jetzt beginnt das eigentliche Experiment. Sie erhalten nun keine Rückmeldung mehr für die Antworten der Verständnisfragen. 
    </p>

    <p>
      Bitte klicken Sie auf den Button "Experiment starten". 
    </p>

    <button @click="$emit('next')">
      Experiment starten
    </button>
  </div>
</template>

<script>
export default {
  name: 'ExperimentIntroPage'
}
</script>

<style scoped>
.page {
  max-width: 850px;
  margin: 30px auto;
  padding: 0 25px;
  text-align: left;
  font-family: Arial, sans-serif;
  font-size: 18px;
  line-height: 1.5;
}

button {
  margin-top: 20px;
  padding: 12px 24px;
  font-size: 18px;
}
</style>

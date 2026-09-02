<!-- ====================================
TRANSPARENCY
This code was developed using the help of AI. The model used: 
OpenAI.(2026). ChatGPT (GPT -5.6 Luna). [Large language model]. https.://chatgpt.com

PLEASE ADD HERE OTHER MODELS THAT ARE USED WHEN DEVELPING THIS CODE FURTHER: 

    ======================================== -->

<template>
  <div class="page">
    <h1>Instruktionen</h1>

    <p>
      Sie werden nun mehrere Sätze lesen.
      Bitte beurteilen Sie, wie natürlich die Sätze klingen.
    </p>

    <button @click="$emit('next')">
      Experiment starten
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
  margin-top: 20px;
  padding: 12px 24px;
  font-size: 18px;
}
</style>
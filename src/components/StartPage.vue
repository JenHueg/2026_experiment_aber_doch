<!-- ====================================
TRANSPARENCY
This code was developed using the help of AI. The model used: 
OpenAI.(2026). ChatGPT (GPT -5.6 Luna). [Large language model]. https.://chatgpt.com

PLEASE ADD HERE OTHER MODELS THAT ARE USED WHEN DEVELPING THIS CODE FURTHER: 

    ======================================== -->

<template>
  <div class="page">
    <h1>Willkommen zu unserem Experiment</h1>

    <p>
      Vielen Dank für Ihr Interesse an unserer Studie.
    </p>

    <button @click="$emit('next')">
      Weiter
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
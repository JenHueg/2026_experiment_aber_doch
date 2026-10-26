# BreakPage.vue

<!-- ====================================
TRANSPARENCY
This code was developed using the help of AI. The model used: 
OpenAI.(2026). ChatGPT (GPT -5.6 Luna). [Large language model]. https.://chatgpt.com
OpenAI.(2026). ChatGPT (GPT -6). [Large language model]. https.://chatgpt.com 

PLEASE ADD HERE OTHER MODELS THAT ARE USED WHEN DEVELPING THIS CODE FURTHER: 

    ======================================== -->
    
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

    <p class="instruction">
      Drücken Sie die Taste <strong>B</strong>, um mit dem zweiten Block fortzufahren.
    </p>
  </div>
</template>

<script>
export default {
  name: 'BreakPage',

  mounted() {
    console.log("BreakPage ist geladen")

    window.addEventListener('keydown', this.handleKeydown)
  },

  beforeDestroy() {
    window.removeEventListener('keydown', this.handleKeydown)
  },

  methods: {

    handleKeydown(event) {
      console.log("Taste gedrückt:", event.key)

      if (event.key === 'b' || event.key === 'B') {
        console.log("B wurde gedrückt")
        this.$emit('next')
      }
    }

  }
}
</script>

<style scoped>
.page {
  max-width: 850px;
  margin-top: 30px;
  padding: 12px 28px;
  text-align: left;
  font-family: Arial, sans-serif;
  font-size: 18px;
  line-height: 1.5;
}

.instruction {
  margin-top: 30px;
  padding: 12px 28px;
  font-size: 18px;
}
</style>
```

# DemographicsPage.vue
<!-- ====================================
TRANSPARENCY
This code was developed using the help of AI. The model used: 
OpenAI.(2026). ChatGPT (GPT -5.6 Luna). [Large language model]. https.://chatgpt.com

PLEASE ADD HERE OTHER MODELS THAT ARE USED WHEN DEVELPING THIS CODE FURTHER: 

    ======================================== -->
    

<template>
  <div class="page">

    <h1>Freiwillige Angaben</h1>

    <p>
      Alle Angaben sind freiwillig-  Klicken Sie bitte auf "Weiter", um das Experiment auf der nächsten Seite zu beenden, indem Sie dort auf die "Beenden"-Schaltfläche klicken. Sie werden dann automatisch nach Prolific weitergeleitet. 
    </p>

  <div class="voluntary-box">
  <div class="form-group">
   <p>
      Da dialektale Unterschiede bei der Bewertung der Äußerungen eine Rolle spielen könnten, interessiert uns, wie Sie folgende Frage stellen würden: 
   </p>

    <!-- Forced Choice Dialect -->

    <div class="form-group">

      <label>
        Das Essen schmeckt heute wieder hervorragend, 
      </label>

      <div class="choice-group">

        <label class="choice">

          <input
            type="radio"
            name="food-question"
            value="gell?"
            v-model="dialectChoice"
          >

          <strong>gell?</strong>

        </label>
    
      </div>

    </div>

        <label class="choice">

          <input
            type="radio"
            name="food-question"
            value="ne?"
            v-model="dialectChoice"
          >

          <strong>ne?</strong>

        </label>

      </div>

    </div>

     <!-- GROWING UP -->

    <div class="form-group">

      <label>
        In welchem Bundesland sind Sie aufgewachsen?
        // only needed if mandatory field : <span class="required">*</span>
      </label>

      <select v-model="federalState">

        <option
          value=""
          disabled
        >
          Bitte auswählen
        </option>

        <option value="außerhalb von Deutschland">
          außerhalb von Deutschland
        </option>

        <option value="Baden-Württemberg">
          Baden-Württemberg
        </option>

        <option value="Bayern">
          Bayern
        </option>

        <option value="Berlin">
          Berlin
        </option>

        <option value="Brandenburg">
          Brandenburg
        </option>

        <option value="Bremen">
          Bremen
        </option>

        <option value="Hamburg">
          Hamburg
        </option>

        <option value="Hessen">
          Hessen
        </option>

        <option value="Mecklenburg-Vorpommern">
          Mecklenburg-Vorpommern
        </option>

        <option value="Niedersachsen">
          Niedersachsen
        </option>

        <option value="Nordrhein-Westfalen">
          Nordrhein-Westfalen
        </option>

        <option value="Rheinland-Pfalz">
          Rheinland-Pfalz
        </option>

        <option value="Saarland">
          Saarland
        </option>

        <option value="Sachsen">
          Sachsen
        </option>

        <option value="Sachsen-Anhalt">
          Sachsen-Anhalt
        </option>

        <option value="Schleswig-Holstein">
          Schleswig-Holstein
        </option>

        <option value="Thüringen">
          Thüringen
        </option>

      </select>

    </div>

    <!-- Error message -->

    <p
      v-if="errorMessage"
      class="error-message"
    >
      {{ errorMessage }}
    </p>

    <!-- Age -->

    <div class="form-group">
      <label>Alter</label>
      <input
        type="number"
        v-model="age"
        min="18"
        max="120"
      >
    </div>

    <!-- Gender -->

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

    <!-- native language -->

    <div class="form-group">
      <label>Muttersprache</label>
      <input
        type="text"
        v-model="nativeLanguage"
        placeholder="z. B. Deutsch"
      >
    </div>

    <!-- Continue button -->

    <button @click="submit">
      Weiter
    </button>

  </div>

</template>

<script>
export default {

  data() {
    return {
      dialectChoice: '',
      federalState: '',
      errorMessage: '',
      age: '',
      gender: '',
      genderSelfDescription: '',
      nativeLanguage: ''
    }
  },

  methods: {

    submit() {

      //========================================
      //Checking for mandatory fields - currently not needed, therefore as comment
      //=======================================

      //if (!this.federalState) {
      //    this.errorMessage =
      //      'Bitte wählen Sie aus, in welchem Bundesland Sie aufgewachsen sind.'
      //    return
      //  }

      //if (!this.dialectChoice) {
      //        this.errorMessage =
      //          'Bitte beantworten Sie die Frage.'
      //        return
      //    }

      //=====================================
      // Reset error message - currently not needed, therefore as comment
      //=====================================

     //  this.errorMessage = ''

      //====================================
      //Transmitting data to App.vue
      //====================================
       
      this.$emit('finished', {
        dialectChoice: this.dialectChoice,
        federalState: this.federalState,
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

.voluntary-box {
  border: 2px solid #ccc;
  border-radius: 8px;
  padding: 25px;
  margin-top: 30px;
  margin-bottom: 30px;
}

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

.required {
  color: red;
}

.choice-group {
  display: flex;
  gap: 30px;
  margin-top: 10px;
}

.choice {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: normal;
  cursor: pointer;
}

.choice input {
  width: auto;
  cursor: pointer;
}

.error-message {
  color: #b00020;
  font-weight: bold;
  margin-top: 20px;
}

button {
  margin-top: 20px;
  padding: 12px 28px;
  font-size: 18px;
}

</style>


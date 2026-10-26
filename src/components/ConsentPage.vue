<template>
  <div class="page">
    <h2>Einverständniserklärung</h2>

    <p>
      Bitte lesen Sie die folgenden Punkte aufmerksam durch
      und bestätigen Sie jeden einzelnen Punkt.
    </p>

    <div class="consent-list">
      <label
        v-for="(point, index) in consentPoints"
        :key="index"
        class="consent-item"
      >
        <input
          type="checkbox"
          v-model="accepted[index]"
        />
        <span>{{ point }}</span>
      </label>
    </div>

    <p v-if="showWarning" class="warning">
      Ohne Ihr Einverständnis können Sie leider nicht an
      der Studie teilnehmen.
    </p>

    <button
      type="button"
      class="next-button"
      :class="{ ready: allAccepted }"
      @click="continueNext"
    >
      Weiter
    </button>
  </div>
</template>

<script>
export default {
  name: 'ConsentPage',

  data() {
    return {
      consentPoints: [
        'Ich bin schriftlich über das Experiment und den Versuchsablauf aufgeklärt worden. Ich habe alle Informationen vollständig gelesen und verstanden.',
        'Ich bin mit der in den Teilnahmeinformationen beschriebenen Handhabung der Daten einverstanden. Die Speicherung der Daten erfolgt vollständig anonym auf einem Server der Universität Tübingen. Die Daten werden zudem als offene Daten vollständig anonym im Internet in einem Datenarchiv zur Verfügung gestellt.',
        'Ich weiß, dass die Teilnahme freiwillig ist und dass ich mein Einverständnis auch während des Experiments jederzeit vor Betätigen des letzten Buttons „Experiment beenden“ ohne Angabe von Gründen zurückziehen kann, was dazu führt, dass meine Daten nicht gespeichert werden. Ich weiß, dass ich in diesem Fall Anspruch auf eine teilweise Vergütung habe. Sobald ich auf den Button „Experiment beenden“ geklickt habe, werden meine anonymen Daten an einen Server in der EU gesendet und gespeichert. Im Anschluss werden die Daten auf einem Server der Universität Tübingen gespeichert.',
        'Meine Daten werden nach Beenden des Experiments anonym gespeichert und sind nicht mehr identifizierbar. Ich kann daher nach Beenden des Experiments keine Löschung meiner Daten mehr verlangen.',
        'Ich bin damit einverstanden, dass meine anonymen Daten zu Forschungszwecken weiterverwendet werden können und mindestens zehn Jahre gespeichert werden.',
        'Ich hatte genügend Zeit für eine Entscheidung und bin einverstanden, an dem Experiment teilzunehmen.'
      ],

      accepted: [false, false, false, false, false, false],
      showWarning: false
    }
  },

  computed: {
    allAccepted() {
      return this.accepted.every(value => value === true)
    }
  },

  methods: {
    continueNext() {
      if (!this.allAccepted) {
        this.showWarning = true
        return
      }

      this.showWarning = false
      this.$emit('next')
    }
  }
}
</script>

<style scoped>
.page {
  max-width: 700px;
  margin: 40px auto;
  padding: 0 20px;
  font-family: Arial, sans-serif;
  text-align: left;
}

.consent-list {
  margin: 24px 0;
}

.consent-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  margin-bottom: 18px;
  line-height: 1.5;
  cursor: pointer;
}

.consent-item input {
  margin-top: 5px;
  flex-shrink: 0;
}

.next-button {
  background-color: #bdbdbd;
  color: white;
  border: none;
  border-radius: 6px;
  padding: 12px 28px;
  font-size: 16px;
  cursor: pointer;
}

.next-button.ready {
  background-color: #1976d2;
}

.warning {
  color: #b00020;
  margin-top: 20px;
  font-weight: bold;
}
</style>
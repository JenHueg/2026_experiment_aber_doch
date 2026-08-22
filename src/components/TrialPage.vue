# TrialPage.vue

<template>

  <div class="trial-container">


    <!-- ==================================================
         FORTSCHRITTSBALKEN
         ================================================== -->

    <div class="progress-wrapper">

      <div class="progress-track">

        <div
          class="progress-fill"
          :style="{ width: progress + '%' }"
        ></div>

      </div>

    </div>


    <!-- ==================================================
         NORMALER TRIAL / RATING-SCREEN
         ================================================== -->

    <div v-if="!showComprehension">


      <!-- Dialog -->

      <div class="dialog-box">

        <p class="speaker">
          <strong>Person A:</strong>
        </p>

        <p class="utterance">
          „{{ currentItem.statement }}“
        </p>


        <p class="speaker">
          <strong>Person B:</strong>
        </p>

        <p class="utterance">
          „{{ currentItem.denial }}“
        </p>

      </div>


      <!-- Bewertung -->

      <div class="scale">

        <div class="scale-labels">

          <span>sehr gut</span>

          <span>sehr schlecht</span>

        </div>


        <div class="scale-options">

          <label
            v-for="n in [5,4,3,2,1]"
            :key="n"
          >

            <input
              type="radio"
              :value="n"
              v-model="response"
            >

            {{ n }}

          </label>

        </div>

      </div>


      <!-- Weiter -->

      <button
        class="next-button"
        :disabled="response === null"
        @click="nextTrial"
      >
        Weiter
      </button>

    </div>


    <!-- ==================================================
         COMPREHENSION QUESTION
         ================================================== -->

    <div
      v-if="showComprehension"
      class="comprehension"
    >


      <!-- Frage -->

      <p class="question">
        {{ currentItem.question }}
      </p>


      <!-- Antwortmöglichkeiten -->

      <div class="comprehension-options">


        <!-- Antwort A -->

        <button
          class="answer-button"
          @click="selectComprehensionAnswer('A')"
        >

          {{ currentItem.answer_A }}

        </button>


        <!-- Antwort B -->

        <button
          class="answer-button"
          @click="selectComprehensionAnswer('B')"
        >

          {{ currentItem.answer_B }}

        </button>


      </div>

    </div>


  </div>

</template>


<script>

export default {

  name: 'TrialPage',


  // ==================================================
  // PROPS
  // ==================================================

  props: {

    stimuli: Array,

    totalTrials: Number,

    startIndex: Number,

    participantID: String,

    // ------------------------------------------------
    // Diese Liste wird jetzt von App.vue übergeben.
    //
    // Beispiel:
    //
    // [1, 4, 7, 10]
    //
    // Das sind die GLOBALEN Trial-Indizes,
    // bei denen eine Comprehension Question
    // angezeigt werden soll.
    // ------------------------------------------------

    comprehensionTrials: {
      type: Array,
      default: () => []
    }

  },


  // ==================================================
  // DATA
  // ==================================================

  data() {

    return {

      // ------------------------------------------------
      // aktuelles Item innerhalb dieses Blocks
      // ------------------------------------------------

      currentIndex: 0,


      // ------------------------------------------------
      // Rating
      // ------------------------------------------------

      response: null,


      // ------------------------------------------------
      // Comprehension
      // ------------------------------------------------

      showComprehension: false,

      comprehensionAnswer: null,

      comprehensionCorrect: null,


      // ------------------------------------------------
      // Daten des aktuellen Trials
      //
      // Diese werden zunächst nach dem Rating
      // zwischengespeichert und erst nach der
      // Comprehension Question endgültig gespeichert.
      // ------------------------------------------------

      currentTrialData: null,


      // ------------------------------------------------
      // Gesamte Ergebnisse
      // ------------------------------------------------

      responses: [],


      // ------------------------------------------------
      // Timer
      // ------------------------------------------------

      trialStartTime: null,

      timeoutID: null,

      countdownID: null,

      remainingTime: 8

    }

  },


  // ==================================================
  // COMPUTED
  // ==================================================

  computed: {


    // ==================================================
    // AKTUELLES ITEM
    // ==================================================

    currentItem() {

      if (
        !this.stimuli ||
        this.currentIndex >= this.stimuli.length
      ) {

        console.error(
          "currentItem ist nicht vorhanden!",
          {
            currentIndex: this.currentIndex,
            stimuliLength: this.stimuli
              ? this.stimuli.length
              : "stimuli fehlt"
          }
        )

        return null

      }


      return this.stimuli[this.currentIndex]

    },


    // ==================================================
    // GLOBALER INDEX DES AKTUELLEN ITEMS
    // ==================================================

    globalCurrentIndex() {

      return (
        this.startIndex +
        this.currentIndex
      )

    },


    // ==================================================
    // ENTSCHEIDUNG:
    // BEKOMMT DIESES ITEM EINE COMPREHENSION QUESTION?
    // ==================================================

    isComprehensionItem() {

      const result =
        this.comprehensionTrials.includes(
          this.globalCurrentIndex
        )


      console.log(
        "------------------------------------------"
      )

      console.log(
        "COMPREHENSION CHECK"
      )

      console.log(
        "Lokaler currentIndex:",
        this.currentIndex
      )

      console.log(
        "StartIndex:",
        this.startIndex
      )

      console.log(
        "Globaler Index:",
        this.globalCurrentIndex
      )

      console.log(
        "Comprehension Trials:",
        this.comprehensionTrials
      )

      console.log(
        "Ist Comprehension Trial?:",
        result
      )

      console.log(
        "------------------------------------------"
      )


      return result

    },


    // ==================================================
    // FORTSCHRITTSBALKEN
    // ==================================================

    progress() {

      console.log(
        "Progress:",
        {
          startIndex: this.startIndex,
          currentIndex: this.currentIndex,
          totalTrials: this.totalTrials
        }
      )


      if (
        !this.totalTrials ||
        this.totalTrials === 0
      ) {

        return 0

      }


      return (

        (
          this.startIndex +
          this.currentIndex
        )
        /
        this.totalTrials

      ) * 100

    }

  },


  // ==================================================
  // CREATED
  // ==================================================

  created() {

    console.log(
      "=========================================="
    )

    console.log(
      "TRIAL PAGE CREATED"
    )

    console.log(
      "=========================================="
    )


    console.log(
      "Stimuli:",
      this.stimuli
    )


    console.log(
      "Anzahl Stimuli in diesem Block:",
      this.stimuli
        ? this.stimuli.length
        : "stimuli fehlt"
    )


    console.log(
      "StartIndex dieses Blocks:",
      this.startIndex
    )


    console.log(
      "Globaler Startindex:",
      this.startIndex
    )


    console.log(
      "Von App.vue übergebene Comprehension Trials:",
      this.comprehensionTrials
    )


    console.log(
      "=========================================="
    )


    // ------------------------------------------------
    // Erstes Item kontrollieren
    // ------------------------------------------------

    if (
      this.stimuli &&
      this.stimuli.length > 0
    ) {

      console.log(
        "Erstes Item:",
        this.stimuli[0]
      )


      console.log(
        "Question:",
        this.stimuli[0].question
      )


      console.log(
        "Answer A:",
        this.stimuli[0].answer_A
      )


      console.log(
        "Answer B:",
        this.stimuli[0].answer_B
      )


      console.log(
        "Correct Answer:",
        this.stimuli[0].correct_answer
      )

    }


    // ------------------------------------------------
    // WICHTIG:
    //
    // Hier wird NICHT mehr zufällig ausgewählt.
    //
    // App.vue entscheidet zentral, welche
    // Trials Comprehension Questions bekommen.
    // ------------------------------------------------


    // ------------------------------------------------
    // Timer für erstes Trial starten
    // ------------------------------------------------

    this.startTrialTimer()

  },


  // ==================================================
  // METHODS
  // ==================================================

  methods: {


    // ==================================================
    // TIMER STARTEN
    // ==================================================

    startTrialTimer() {

      console.log(
        "=========================================="
      )

      console.log(
        "START TRIAL TIMER"
      )

      console.log(
        "currentIndex:",
        this.currentIndex
      )

      console.log(
        "globalCurrentIndex:",
        this.globalCurrentIndex
      )

      console.log(
        "showComprehension:",
        this.showComprehension
      )

      console.log(
        "currentItem:",
        this.currentItem
      )


      // ------------------------------------------------
      // Sicherheitscheck
      // ------------------------------------------------

      if (!this.currentItem) {

        console.error(
          "TIMER NICHT GESTARTET:",
          "currentItem ist nicht vorhanden."
        )

        return

      }


      // ------------------------------------------------
      // Alten Timeout löschen
      // ------------------------------------------------

      if (this.timeoutID) {

        clearTimeout(
          this.timeoutID
        )

        this.timeoutID = null

      }


      // ------------------------------------------------
      // Alten Countdown löschen
      // ------------------------------------------------

      if (this.countdownID) {

        clearInterval(
          this.countdownID
        )

        this.countdownID = null

      }


      // ------------------------------------------------
      // Startzeit speichern
      // ------------------------------------------------

      this.trialStartTime =
        Date.now()


      this.remainingTime =
        8


      // ------------------------------------------------
      // Countdown
      // ------------------------------------------------

      this.countdownID =
        setInterval(() => {

          this.remainingTime--


          if (
            this.remainingTime <= 0
          ) {

            clearInterval(
              this.countdownID
            )

            this.countdownID = null

          }

        }, 1000)


      // ------------------------------------------------
      // 8-Sekunden-Timeout
      // ------------------------------------------------

      this.timeoutID =
        setTimeout(() => {

          console.log(
            "=========================================="
          )

          console.log(
            "TIMEOUT"
          )

          console.log(
            "currentIndex:",
            this.currentIndex
          )

          console.log(
            "globalCurrentIndex:",
            this.globalCurrentIndex
          )

          console.log(
            "showComprehension:",
            this.showComprehension
          )


          // Countdown stoppen

          if (this.countdownID) {

            clearInterval(
              this.countdownID
            )

            this.countdownID = null

          }


          // Trial abschließen

          this.nextTrial()

        }, 8000)

    },


    // ==================================================
    // COMPREHENSION ANTWORT AUSWÄHLEN
    // ==================================================

    selectComprehensionAnswer(answer) {

      console.log(
        "=========================================="
      )

      console.log(
        "COMPREHENSION ANTWORT"
      )

      console.log(
        "Antwort der VP:",
        answer
      )

      console.log(
        "Richtige Antwort:",
        this.currentItem.correct_answer
      )


      // ------------------------------------------------
      // Antwort speichern
      // ------------------------------------------------

      this.comprehensionAnswer =
        answer


      // ------------------------------------------------
      // Antwort überprüfen
      // ------------------------------------------------

      this.comprehensionCorrect =
        answer ===
        String(
          this.currentItem.correct_answer
        ).trim()


      console.log(
        "Comprehension korrekt?:",
        this.comprehensionCorrect
      )


      // ------------------------------------------------
      // Comprehension Trial abschließen
      // ------------------------------------------------

      this.nextTrial()

    },


    // ==================================================
    // NEXT TRIAL
    // ==================================================

    nextTrial() {

      console.log(
        "=========================================="
      )

      console.log(
        "NEXT TRIAL"
      )

      console.log(
        "currentIndex:",
        this.currentIndex
      )

      console.log(
        "globalCurrentIndex:",
        this.globalCurrentIndex
      )

      console.log(
        "showComprehension:",
        this.showComprehension
      )

      console.log(
        "currentItem:",
        this.currentItem
      )


      // ------------------------------------------------
      // Sicherheitscheck
      // ------------------------------------------------

      if (!this.currentItem) {

        console.error(
          "NEXT TRIAL ABGEBROCHEN:",
          "currentItem ist nicht vorhanden."
        )

        return

      }


      // ------------------------------------------------
      // Timer stoppen
      // ------------------------------------------------

      if (this.timeoutID) {

        clearTimeout(
          this.timeoutID
        )

        this.timeoutID = null

      }


      if (this.countdownID) {

        clearInterval(
          this.countdownID
        )

        this.countdownID = null

      }


      // ==================================================
      // FALL 1:
      // COMPREHENSION SCREEN
      // ==================================================

      if (
        this.showComprehension
      ) {

        console.log(
          "------------------------------------------"
        )

        console.log(
          "COMPREHENSION SCREEN WIRD ABGESCHLOSSEN"
        )


        // ------------------------------------------------
        // Reaktionszeit berechnen
        // ------------------------------------------------

        let comprehensionReactionTimeMs =
          "NA"


        if (
          this.trialStartTime &&
          this.comprehensionAnswer !== null
        ) {

          comprehensionReactionTimeMs =
            Date.now() -
            this.trialStartTime

        }


        // ------------------------------------------------
        // Comprehension-Daten speichern
        // ------------------------------------------------

        this.currentTrialData.comprehensionAnswer =
          this.comprehensionAnswer === null
            ? "NA"
            : this.comprehensionAnswer


        this.currentTrialData.comprehensionCorrect =
          this.comprehensionCorrect === null
            ? "NA"
            : this.comprehensionCorrect


        this.currentTrialData.comprehensionReactionTimeMs =
          comprehensionReactionTimeMs


        this.currentTrialData.comprehensionReactionTime =
          comprehensionReactionTimeMs === "NA"
            ? "NA"
            : this.formatDuration(
                comprehensionReactionTimeMs
              )


        console.log(
          "Comprehension-Daten:",
          {
            answer:
              this.currentTrialData.comprehensionAnswer,

            correct:
              this.currentTrialData.comprehensionCorrect,

            reactionTimeMs:
              this.currentTrialData
                .comprehensionReactionTimeMs
          }
        )


        // ------------------------------------------------
        // Vollständiges Trial speichern
        // ------------------------------------------------

        this.responses.push(
          this.currentTrialData
        )


        console.log(
          "VOLLSTÄNDIGES TRIAL GESPEICHERT:",
          this.currentTrialData
        )


        // ------------------------------------------------
        // Comprehension zurücksetzen
        // ------------------------------------------------

        this.showComprehension =
          false

        this.comprehensionAnswer =
          null

        this.comprehensionCorrect =
          null

        this.currentTrialData =
          null

        this.response =
          null


        // ------------------------------------------------
        // Prüfen, ob letztes Trial
        // ------------------------------------------------

        if (
          this.currentIndex ===
          this.stimuli.length - 1
        ) {

          console.log(
            "LETZTES TRIAL ABGESCHLOSSEN."
          )


          this.$emit(
            'finished',
            this.responses
          )


          return

        }


        // ------------------------------------------------
        // Nächstes Trial
        // ------------------------------------------------

        this.currentIndex++


        console.log(
          "Nächstes Trial:",
          this.currentIndex
        )


        this.startTrialTimer()


        return

      }


      // ==================================================
      // FALL 2:
      // NORMALER RATING SCREEN
      // ==================================================

      console.log(
        "------------------------------------------"
      )

      console.log(
        "RATING SCREEN WIRD ABGESCHLOSSEN"
      )


      // ------------------------------------------------
      // Rating-Reaktionszeit
      // ------------------------------------------------

      let reactionTimeMs =
        "NA"


      if (
        this.trialStartTime &&
        this.response !== null
      ) {

        reactionTimeMs =
          Date.now() -
          this.trialStartTime

      }


      console.log(
        "Rating:",
        this.response
      )


      console.log(
        "Rating Reaction Time:",
        reactionTimeMs
      )


      // ------------------------------------------------
      // Aktuelles Trial zwischenspeichern
      // ------------------------------------------------

      this.currentTrialData = {

        participantID:
          this.participantID,

        item:
          this.currentItem.item,

        condition:
          this.currentItem.condition,

        list:
          this.currentItem.list,

        statement:
          this.currentItem.statement,

        denial:
          this.currentItem.denial,

        rating:
          this.response === null
            ? "NA"
            : this.response,

        reactionTimeMs:
          reactionTimeMs,

        reactionTime:
          reactionTimeMs === "NA"
            ? "NA"
            : this.formatDuration(
                reactionTimeMs
              ),


        // ------------------------------------------------
        // Standardmäßig NA.
        //
        // Falls eine Comprehension Question kommt,
        // werden diese Werte später überschrieben.
        // ------------------------------------------------

        comprehensionAnswer:
          "NA",

        comprehensionCorrect:
          "NA",

        comprehensionReactionTimeMs:
          "NA",

        comprehensionReactionTime:
          "NA"

      }


      console.log(
        "Rating-Daten zwischengespeichert:",
        this.currentTrialData
      )


      // ------------------------------------------------
      // Rating zurücksetzen
      // ------------------------------------------------

      this.response =
        null


      // ==================================================
      // ENTSCHEIDUNG:
      // COMPREHENSION QUESTION ODER NICHT?
      // ==================================================

      console.log(
        "------------------------------------------"
      )

      console.log(
        "PRÜFE COMPREHENSION"
      )

      console.log(
        "Globaler Trial-Index:",
        this.globalCurrentIndex
      )

      console.log(
        "Comprehension Trials:",
        this.comprehensionTrials
      )

      console.log(
        "Ist Comprehension Trial?:",
        this.isComprehensionItem
      )


      // ==================================================
      // FALL 2A:
      // COMPREHENSION QUESTION
      // ==================================================

      if (
        this.isComprehensionItem
      ) {

        console.log(
          "##########################################"
        )

        console.log(
          "COMPREHENSION QUESTION WIRD ANGEZEIGT"
        )

        console.log(
          "Question:",
          this.currentItem.question
        )

        console.log(
          "Answer A:",
          this.currentItem.answer_A
        )

        console.log(
          "Answer B:",
          this.currentItem.answer_B
        )

        console.log(
          "##########################################"
        )


        // ------------------------------------------------
        // Comprehension Screen anzeigen
        // ------------------------------------------------

        this.showComprehension =
          true


        // ------------------------------------------------
        // Timer für Frage neu starten
        // ------------------------------------------------

        this.startTrialTimer()


      }


      // ==================================================
      // FALL 2B:
      // KEINE COMPREHENSION QUESTION
      // ==================================================

      else {

        console.log(
          "KEINE COMPREHENSION QUESTION"
        )


        // ------------------------------------------------
        // Trial direkt speichern
        // ------------------------------------------------

        this.responses.push(
          this.currentTrialData
        )


        console.log(
          "Normales Trial gespeichert:",
          this.currentTrialData
        )


        this.currentTrialData =
          null


        // ------------------------------------------------
        // Prüfen, ob letztes Trial
        // ------------------------------------------------

        if (
          this.currentIndex ===
          this.stimuli.length - 1
        ) {

          console.log(
            "LETZTES TRIAL ABGESCHLOSSEN."
          )


          this.$emit(
            'finished',
            this.responses
          )


          return

        }


        // ------------------------------------------------
        // Nächstes Trial
        // ------------------------------------------------

        this.currentIndex++


        console.log(
          "Nächstes Trial:",
          this.currentIndex
        )


        this.startTrialTimer()

      }

    },


    // ==================================================
    // REAKTIONSZEIT FORMATIEREN
    // ==================================================

    formatDuration(ms) {

      if (
        ms === "NA" ||
        ms === null ||
        ms === undefined
      ) {

        return "NA"

      }


      const totalSeconds =
        Math.floor(
          ms / 1000
        )


      const hours =
        Math.floor(
          totalSeconds / 3600
        )


      const minutes =
        Math.floor(
          (totalSeconds % 3600) / 60
        )


      const seconds =
        totalSeconds % 60


      return (

        String(hours)
          .padStart(2, "0")

        +

        "-"

        +

        String(minutes)
          .padStart(2, "0")

        +

        "-"

        +

        String(seconds)
          .padStart(2, "0")

      )

    }

  }

}

</script>


<style scoped>

.trial-container {

  max-width: 800px;

  margin: 50px auto;

  font-family: Arial, sans-serif;

}


/* ==================================================
   FORTSCHRITTSBALKEN
   ================================================== */

.progress-wrapper {

  width: 100%;

  margin-bottom: 30px;

}


.progress-track {

  width: 100%;

  height: 14px;

  background-color: #e0e0e0;

  border-radius: 7px;

  overflow: hidden;

}


.progress-fill {

  height: 100%;

  width: 0%;

  background-color: #4CAF50;

  transition: width 0.3s ease;

}


/* ==================================================
   DIALOG
   ================================================== */

.dialog-box {

  margin: 40px 0;

  padding: 30px;

  border: 1px solid #ddd;

  border-radius: 10px;

}


.speaker {

  margin-bottom: 5px;

}


.utterance {

  font-size: 1.2em;

  margin-bottom: 25px;

}


/* ==================================================
   RATING
   ================================================== */

.scale {

  margin: 40px 0;

}


.scale-labels {

  display: flex;

  justify-content: space-between;

  margin-bottom: 10px;

}


.scale-options {

  display: flex;

  justify-content: space-between;

}


.scale-options label {

  display: flex;

  flex-direction: column;

  align-items: center;

}


/* ==================================================
   WEITER-BUTTON
   ================================================== */

.next-button {

  margin-top: 30px;

  padding: 12px 28px;

  font-size: 18px;

}


/* ==================================================
   COMPREHENSION
   ================================================== */

.comprehension {

  margin: 80px 0;

  text-align: center;

}


.question {

  font-size: 1.3em;

  margin-bottom: 40px;

}


.comprehension-options {

  display: flex;

  justify-content: space-between;

  gap: 30px;

}


.answer-button {

  flex: 1;

  padding: 20px;

  font-size: 18px;

  cursor: pointer;

}

</style>
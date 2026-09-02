# TrialPage.vue

<!-- ====================================
TRANSPARENCY
This code was developed using the help of AI. The model used: 
OpenAI.(2026). ChatGPT (GPT -5.6 Luna). [Large language model]. https.://chatgpt.com

PLEASE ADD HERE OTHER MODELS THAT ARE USED WHEN DEVELPING THIS CODE FURTHER: 

    ======================================== -->


<template>

  <div class="trial-container">


    <!-- ==================================================
         PROGRESS BAR
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
         NORMAL TRIAL / RATING-SCREEN
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

      <!-- ============================================
          RATING
          ============================================= -->

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


      <!-- ===========================================
          CONTINUE
          ============================================ -->

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

      <!-- Question -->

      <p class="question">
        {{ currentItem.question }}
      </p>


      <!-- response possibilties -->

      <div class="comprehension-options">

      <!-- Anwer A -->

        <button
          class="answer-button"
          @click="selectComprehensionAnswer('A')"
        >

          {{ currentItem.answer_A }}

        </button>

      <!-- Answer B -->

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
    // This Liste is hand-over to App.vue.
    //
    // Example:
    //
    // [1, 4, 7, 10]
    //
    // Trial-Indizes in one of the Blocks, where comprehension question is shown
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
      // current Item in block
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
      // Data of current trial
      //
      // They are safed after rating and will finally be safed after comprehension question 
      // ------------------------------------------------

      currentTrialData: null,

      // ------------------------------------------------
      // Full responses
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
    // CURRENT ITEM
    // ==================================================

    currentItem() {
      if (
        !this.stimuli ||
        this.currentIndex >= this.stimuli.length
      ) {
        console.error(
          "currentItem is not available!",
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
    // GLOBAL INDEX OF CURRENT ITEM
    // ==================================================

    globalCurrentIndex() {
      return (
        this.startIndex +
        this.currentIndex
      )
    },

    // ==================================================
    // DECISION:
    // DOES THIS ITEM GET A COMPREHENSION QUESTION?
    // ==================================================

    isComprehensionItem() {

      const result =
        this.comprehensionTrials.includes(
          this.currentIndex
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
        "Global Index:",
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

      return result

    },


    // ==================================================
    // PROGRESS BAR
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
      "TRIAL PAGE CREATED"
    )

    console.log(
      "Stimuli:",
      this.stimuli
    )

    console.log(
      "Number of stimuli in this block:",
      this.stimuli
        ? this.stimuli.length
        : "stimuli fehlt"
    )

    console.log(
      "StartIndex of block:",
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

    // ------------------------------------------------
    // CONTROLL FIRST ITEM
    // ------------------------------------------------

    if (
      this.stimuli &&
      this.stimuli.length > 0
    ) {

      console.log(
        "First Item:",
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
    // IMPORTANT:
    //
    // From now on no randomisation.
    //
    // App.vue decides centrally, which
    // Trials get a Comprehension Questions.
    // ------------------------------------------------

    // ------------------------------------------------
    // START TIMER FOR FIRST TRIAL
    // ------------------------------------------------

    this.startTrialTimer()

  },


  // ==================================================
  // METHODS
  // ==================================================

  methods: {

    // ==================================================
    // START TIMER
    // ==================================================

    startTrialTimer() {

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
      // SECURITY CHECK
      // ------------------------------------------------

      if (!this.currentItem) {

        console.error(
          "Timer didn't start:",
          "currentItem i not available."
        )

        return

      }

      // ------------------------------------------------
      // DELETE OLD TIMEOUT
      // ------------------------------------------------

      if (this.timeoutID) {
        clearTimeout(
          this.timeoutID
        )
        this.timeoutID = null
      }

      // ------------------------------------------------
      // DELETE OLD COUNTDOWN
      // ------------------------------------------------

      if (this.countdownID) {
        clearInterval(
          this.countdownID
        )
        this.countdownID = null
      }

      // ------------------------------------------------
      // SAFE STARTING TINE
      // ------------------------------------------------

      this.trialStartTime =
        Date.now()

      this.remainingTime =
        10

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
      // SET TIME-OUT TIME
      // ------------------------------------------------

      this.timeoutID =
        setTimeout(() => {

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

          // Stop countdown 

          if (this.countdownID) {
            clearInterval(
              this.countdownID
            )
            this.countdownID = null
          }

          // Trial closed

          this.nextTrial()

        }, 10000)

    },

    // ==================================================
    // CHOOSE COMPREHENSION ANSWER
    // ==================================================

    selectComprehensionAnswer(answer) {

      console.log(
        "COMPREHENSION ANSWER"
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
      // Save answer
      // ------------------------------------------------

      this.comprehensionAnswer =
        answer

      // ------------------------------------------------
      // Check answer 
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
      // Comprehension Trial closed
      // ------------------------------------------------

      this.nextTrial()

    },

    // ==================================================
    // NEXT TRIAL
    // ==================================================

    nextTrial() {

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
      // Security check
      // ------------------------------------------------

      if (!this.currentItem) {
        console.error(
          "NEXT TRIAL ABGEBROCHEN:",
          "currentItem ist nicht vorhanden."
        )
        return
      }

      // ------------------------------------------------
      // Stop timer
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
      // CASE 1:
      // COMPREHENSION SCREEN
      // ==================================================

      if (
        this.showComprehension
      ) {

        console.log(
          "COMPREHENSION SCREEN CLOSED"
        )

        // ------------------------------------------------
        // Calculate reaction times
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
        // Safe Comprehension data
        // ------------------------------------------------

          if (
            this.isComprehensionItem &&
            this.comprehensionAnswer === null
          ) {

            this.currentTrialData.comprehensionAnswer = "missing"
            this.currentTrialData.comprehensionCorrect = "missing"
          }

          // Comprehension Question wurde angezeigt
          // und wurde beantwortet
          else if (
            this.isComprehensionItem &&
            this.comprehensionAnswer !== null
          ) {

            this.currentTrialData.comprehensionAnswer =
              this.comprehensionAnswer

            this.currentTrialData.comprehensionCorrect =
              this.comprehensionCorrect

          }

          // No comprehension question presented for this trial
          else {

            this.currentTrialData.comprehensionAnswer = "NA"
            this.currentTrialData.comprehensionCorrect = "NA"

          }

        this.currentTrialData.comprehensionReactionTimeMs =
          comprehensionReactionTimeMs

        this.currentTrialData.comprehensionReactionTime =
          comprehensionReactionTimeMs === "NA"
            ? "NA"
            : this.formatDuration(
                comprehensionReactionTimeMs
              )

        console.log(
          "Comprehension data:",
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
        // Safe complete trial
        // ------------------------------------------------

        this.responses.push(
          this.currentTrialData
        )

        console.log(
          "TRIAL SAFED",
          this.currentTrialData
        )

        // ------------------------------------------------
        // Reset comprehension
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
        // CHECK WHETHER LAST TRIAL
        // ------------------------------------------------

        if (
          this.currentIndex ===
          this.stimuli.length - 1
        ) {

          console.log(
            "LAST TRIAL COMPLETED."
          )

          this.$emit(
            'finished',
            this.responses
          )

          return

        }

        // ------------------------------------------------
        // Next Trial
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
      // CASE 2:
      // NORMAL RATING SCREEN
      // ==================================================

      console.log(
        "RATING SCREEN WIRD ABGESCHLOSSEN"
      )

      // ------------------------------------------------
      // Rating of reaction time
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
      // Safe current trial in between
      // ------------------------------------------------

      this.currentTrialData = {

        participantID: this.participantID,
        item: this.currentItem.item,
        condition: this.currentItem.condition,
        list: this.currentItem.list,
        statement: this.currentItem.statement,
        denial: this.currentItem.denial,
        question: this.currentItem.question,
        answer_A: this.currentItem.answer_A,
        answer_B: this.currentItem.answer_B,
        correct_answer: this.currentItem.correct_answer, 
        rating:
          this.response === null
            ? "NA"
            : this.response,
        reactionTimeMs: reactionTimeMs,
        reactionTime:
          reactionTimeMs === "NA"
            ? "NA"
            : this.formatDuration(
                reactionTimeMs
              ),


        // ------------------------------------------------
        // NA per default
        //
        // When comprehension question occurs, answers are overriden
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
        "Rating-Daten safed temporarily:",
        this.currentTrialData
      )

      // ------------------------------------------------
      // Reset rating
      // ------------------------------------------------

      this.response =
        null

      // ==================================================
      // DECISON
      // COMPREHENSION QUESTION OR NOT
      // ==================================================

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
      // CASE 2A:
      // COMPREHENSION QUESTION
      // ==================================================

      if (
        this.isComprehensionItem
      ) {

       
        console.log(
          "COMPREHENSION QUESTION IS SHOWN"
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

        // ------------------------------------------------
        // Show Comprehension Screen 
        // ------------------------------------------------

        this.showComprehension =
          true


        // ------------------------------------------------
        // Restart timer for  question
        // ------------------------------------------------

        this.startTrialTimer()

      }


      // ==================================================
      // CASE B
      // NO COMPREHENSION QUESTION
      // ==================================================

      else {
        console.log(
          "NO COMPREHENSION QUESTION"
        )

        // ------------------------------------------------
        // Trial safed directly
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
        // Check whether last trial
        // ------------------------------------------------

        if (
          this.currentIndex ===
          this.stimuli.length - 1
        ) {
          console.log(
            "LAST TRIAL COMPLETED."
          )

          this.$emit(
            'finished',
            this.responses
          )

          return

        }

        // ------------------------------------------------
        // Next Trial
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
    // FORMAT REACTION TIMES
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

.next-button {
  margin-top: 30px;
  padding: 12px 28px;
  font-size: 18px;
}

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
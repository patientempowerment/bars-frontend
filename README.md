# EMPOWER

An app that visualizes the effects of changing inputs on the results of given logistic regression outputs.
It can be used for any kind of data. For the example configs we used a health use case to predict tuberculosis, diabetes, asthma and COPD on certain parameters like age, weight, height and smoking behavior.

## Steps to run
1. Clone the project
2. Configure
    * Connect to a running server of [patientEmpowerment](https://github.com/KBorchar/patientEmpowerment) via editing `assets/server.conf`. 
    * OR:
    * To configure the input and output manually, edit `assets/feature-config.json` and `assets/models.json` as described further down.
The example files were created with the [backend](https://github.com/KBorchar/patientEmpowerment).
3. To configure the displayed titles of the output, edit `assets/labels.conf`.
4. Run the app in an IDE of your choice (e.g. [Android Studio with Flutter Plugin](https://androiddvlpr.com/flutter-android-studio/)).

### Configuration
#### feature-config.json
#### models.json
## How to use
There are two visual representations o the same concept: Bars on startup and Bubbles once you swipe one page to the right.
Should you have left out some input parameters, the app will assume the means given in `assets/models.json`.

### Bars
[TODO: INSERT PIC]
On the left side, you can put in your data and press the button in the middle to get the output. You can also change the input while the output is displayed or hide the output bars again by pressing the same button in the middle. To reset to means, press the floating button on the bottom right.

### Bubbles
[TODO: INSERT PIC]


## Contributing
We are happy if you'd want to contribute to the project. To get into the development, you might want to take some things into account.
### Naming
We have a schema of naming the inputs "features" because they are the features of the machine learning algorithm and naming the outputs "labels", which is again the ML term.
The two pages, Bars and Bubbles are called "prototype" because they are just two of many possible visualization possibilities and not final.

### Where can you find what?
Generally, the code is in the `/lib` folder. `/lib/main.dart` is where the main application is defined. From there `/lib/barPrototype.dart` and `/lib/bubblePrototype.dart` are called with their respective widgets.
The prediction logic you can find in `/lib/predictions.dart`. The configs are loaded in `/lib/utils.dart`.
Both, Bars and Bubbles prototype, use the same input fields, defined in `/widgets/radioButtons.dart` and `/widgets/sliders.dart`.


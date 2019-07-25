# EMPOWER

An app that visualizes the effects of changing inputs on the results of given logistic regression outputs.
It can be used for any kind of clean data. For the example configuration, we use a health use case to predict tuberculosis, diabetes, asthma and COPD on life style choices and patient parameters like age, weight, etc.

## Steps to run
1. Clone the project
2. Configure
    * Connect to a running server of [patientEmpowerment](https://github.com/KBorchar/patientEmpowerment) via editing `assets/server.conf` and load `assets/feature-config.json` and `assets/models.json` from there. 
    * OR:
    * To configure the input and output manually, set the "fallbacks" field in `assets/server.conf` to appropriate config files as described further down.
The example files were created with the [backend](https://github.com/KBorchar/patientEmpowerment).
3. To configure the displayed titles of the output, edit `assets/labels.conf`.
4. Run the app in an IDE of your choice (e.g. [Android Studio with Flutter Plugin](https://androiddvlpr.com/flutter-android-studio/)).

### Configuration
#### server.conf
In `/assets/server.conf` you can configure the server address, the database that should be used and the mongo collection. In case the server is not reachable, you need to specify fallbacks for local files where similar information can be found.
```
{
  "address": "http://172.20.24.28:5050",
  "database": {
    "db": "ukbb",
    "collection": "ahri"
  },
  "fallbacks": {
    "feature-config": "assets/feature-config.json",
    "models": "assets/models.json"
  }
}
```

#### feature-config.json
The content of the feature config should look similar to this:
```
{
  "copd": {
    "title": "COPD",
    "choices": {
      "Yes": 1,
      "No": 0
    }
  },
  "age": {
    "title": "Age",
    "slider_min": 40,
    "slider_max": 70
  },
  ...
}
```
It represents the possible input fields.
As key, you use the feature name, give it a title and decide whether it should be represented as a slider or radio choice buttons. For radio buttons, specify a list of available choices with their correlated number representation in your ML algorithm. For a slider, specify the minimal and maximal value that the user should be able to input.

#### models.json
In `models.json` you specify, per label, the ML determined coefficients for each feature as well as their means. It should look similar to this:
```
{
  "asthma": {
    "features": {
      "age": {
        "coef": 0.08657563511716311, 
        "mean": 56.90638617580766
      },
      ...
    }
  },
  ...
}
```
First key is the label name, in this case "COPD". Inside the "feature" argument you then can specify a list of features that influence this label with the respective coefficients (at key "coeff") and means (at key "mean"). Repeat this for all features and labels.

#### labels.conf
In `assets/labels.conf` you specify all labels that you want to predict for, that also have a representation in `assets/models.json` (!) as a simple list with the key "labels". That is used to query the models.json from the server.
With the key "label_titles", you need to set the corresponding title to a label name.

```
{
  "labels": [
  	"asthma",
   ...
   ],
  "label_titles": {
    "asthma": "Asthma",
    ...
  }
}
```


## How to use
There are two visual representations of the same concept: Bars on startup and Bubbles once you swipe one page to the right.
Should you have left out some input parameters, the app will assume the means given in `assets/models.json`.

### Bars
![Alt text](/assets/bars_prototype.png "Bars Prototype")
On the left side, you can put in your data and press the button in the middle to get the output. You can also change the input while the output is displayed or hide the output bars again by pressing the same button in the middle. To reset to means, press the floating button on the bottom right.

### Bubbles
![Alt text](/assets/bubbles_prototype.png "Bubbles Prototype")
In Bubbles Prototype the input fields have a bubble representation. They are located at the top of the screen. The output is also in a circular form in the screen center around a center image. Each output bubble representing one ML prediction label. You can input your data by dragging or clicking an input bubble. A dialog opens and asks you to input your data. By pressing "ok" the change is propagated to the output bubbles and their size changes according to the new probabilities. Additionally there are particles, small bubbles, flying from the input to the influenced output bubble(s) to indicate their correlation.


## Contributing
We are happy if you'd want to contribute to the project. To get into the development, you might want to take some things into account.
### Naming
We have a schema of naming the inputs "features" because they are the features of the machine learning algorithm and naming the outputs "labels", which is again the ML term.
The two pages, Bars and Bubbles are called "prototype" because they are just two of many possible visualization possibilities and not final.

### Where can you find what?
Generally, the code is in the `/lib` folder. `/lib/main.dart` is where the main application is defined. From there `/lib/barPrototype.dart` and `/lib/bubblePrototype.dart` are called with their respective widgets.
The prediction logic you can find in `/lib/predictions.dart`. The configs are loaded in `/lib/utils.dart`.
Both, Bars and Bubbles prototype, use the same input fields, defined in `/widgets/radioButtons.dart` and `/widgets/sliders.dart`.


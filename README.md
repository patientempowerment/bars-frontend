# EMPOWER

Empower is an app that shows the relations between changes in feature vectors and the resulting effects on predictions made by pre-trained logistic regressors. It does this by providing users with an input interface to make changes to feature values and on the fly presenting the resulting effects on the model's prediction results.
It can be used for any kind of clean data. For the example configuration, we use a health use case to predict tuberculosis, diabetes, asthma and COPD on life style choices and patient parameters like age, weight, etc.

## Steps to run
1. Clone the project
2. Configure
    * Connect to a running server of [empower-backend](https://github.com/patientempowerment/empower-backend) via editing `assets/configs/server.conf`. Use the Admin View in the side menu on the top left to configure the labels to train on. Additionally you should edit assets/configs/features.json to configure what input fields should be displayed. 
    * OR:
    * To configure the input and output manually, set the "fallbacks" field in `assets/configs/server.conf` to appropriate config files (see Configuration).
The example files were created by the [empower-backend](https://github.com/patientempowerment/empower-backend).
3. To configure the user-facing names of the output labels, edit `assets/configs/labels.conf`.
4. Run the app in an IDE of your choice (e.g. [Android Studio with Flutter Plugin](https://androiddvlpr.com/flutter-android-studio/)).

### Configuration
#### server.conf
In `/assets/configs/server.conf` you can configure the server address, the database that should be used and the mongo collection. In case the server is not reachable, you need to specify fallbacks for local files where similar information can be found.
```
{
  "address": <IPAdress:port>,
  "database": {
    "db": <DBName>,
    "collection": <collectionName>
  },
  "fallbacks": {
    "feature-config": "assets/configs/features.json",
    "models": "assets/configs/models.json"
  }
}
```

#### features.json
The content of the feature config should look similar to this:
```
{
  <feature1>: {
    "title": <featureTitle1>,
    "choices": {
      "Yes": 1,
      "No": 0
    },
    "mean": 0.014438747643462481
  },
  <feature2>: {
    "title": <featureTitle2>,
    "slider_min": 40,
    "slider_max": 70,
    "mean": 56.90638617580766
  },
  ...
}
```
It represents the possible input fields.
As key, you use the feature name. Give it a user-facing title and decide whether it should be represented as a slider or choice. For choices, specify a list of available choices with their correlating value in the original data set. For a slider, specify the minimal and maximal value that the user should be able to input.

#### models.json
In `models.json` you specify, per label, the coefficients for each feature as well as their means in the original data set. It should look similar to this:
```
{
  <label1>: {
    "features": {
      <feature1>: {
        "coef": 0.08657563511716311, 
        "mean": 56.90638617580766
      },
      ...
    }
  },
  ...
}
```
First key is the label, in this case <label1>. "features" contains a list of all respective features, their coefficients, and their means.  This file is auto-generated, whenever the backend fits the corresponding model.

#### labels.conf
`assets/configs/labels.conf` specifies all labels to predict for, and their user-facing names. It is used to query the models.json from the server.
With the key "label_titles", you need to set the corresponding title to a label name.

```
{
  "labels": [
  	<label1>,
   ...
   ],
  "label_titles": {
    <label1>: <labelTitle1>,
    ...
  }
}
```


## How to use
There are two visual representations of the same concept: A bar chart (default), and a more interactive prototype. Swipe right on the bar chart screen to access it.
Should any inputs be empty, the app will assume the corresponding feature's mean (from `assets/configs/models.json`).

### Bars
![Alt text](/assets/images/bars_prototype.png "Bars Prototype")
On the left side, users can input their data and press the button in the middle to get the output. The output reacts in real time to any changes on the input. You can hide it again by pressing the same button in the middle. To reset all inputs to their means, press the floating action button on the bottom right.

### Bubbles
![Alt text](/assets/images/bubbles_prototype.png "Bubbles Prototype")
In the 'Bubbles' prototype the input fields have a bubble representation. They are initially located at the top of the screen. The output is represented by fixed label bubbles, arranged around the center image. Each label bubble represents one label to predict on. Users can input their data by dragging or tapping an input bubble, upon which an input dialog opens. By pressing "ok" the change is propagated to the label bubbles and their size changes according to the new probabilities. Additionally, there are particles, small bubbles, flying from the input to the influenced label bubble(s) to indicate their correlation.


## Contributing
We are happy if you'd want to contribute to the project. To get into the development, you might want to take some things into account.

### Where can you find what?
Generally, the code is in the `/lib` folder. `/lib/main.dart` is where the main application is defined. From there `/lib/barPrototype.dart` and `/lib/bubblePrototype.dart` are called with their respective widgets.
The prediction logic you can find in `/lib/predictions.dart`. The configs are loaded in `/lib/utils.dart`.
Both, Bars and Bubbles prototype, use the same input fields, defined in `/widgets/radioButtons.dart` and `/widgets/sliders.dart`.


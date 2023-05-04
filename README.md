# Frontend for Visualization of Distribution System App

This project enables users to add icons at different substation location and add lines along the path of cables.

## Installation
To run this App on your local machine, follow these steps:

1. Clone the repository to your local machine.
2. Navigate to the project directory.
3. Run `flutter pub get` to install all dependencies.
4. Change the url in the `constants.dart` file to the url of the backend server (for example : after hosting the backend server or ngrok link while testing backend)

## Google Maps API Usage
```
<meta-data android:name="com.google.android.geo.API_KEY"
            android:value=<API-KEY>/>
```
Replace API-KEY with your API Key in the `AndroidManifest.xml` file.

## App Usage
### Non Admin User
Viewing Substation Details: Click on the Substation Icon , Further click RMU(ring main unit),transformer icon or LT panel(low tension panel) to view respective component details.
Viewing Cable Details: Click on the Cable for which you want to view details.

### Admin User
All Viewing functionality are similar as Non Admin User

Adding Substation: 
1. Go to the substation location
2. Click on the `Add Substation` button

Adding Transformer:
1. Click on substation icon which you want to add transformer
2. Click on `+` icon 

Adding Cable:
1. Go to starting location of cable and click on `New Line` to start creation of line
2. Move along the path of cable and keep clicking `Add Point` button (on a turn click more times and on a straight path we can click only at starting and ending point)
3. Finally click on `create` button to complete creation

Adding Component Data:
1. Click on respective component(Cable,Rmu,Transformer,LT panel)
2. After a form opens , click on `+` button to add new data
3. Click on `Save` button

## Contact information
If you have any questions or issues with the Code, please contact the project maintainers at phone:`8800402403`(Harsh Arora) ,`8871853272`(Sanskar Gupta) , `9993646823`(Chirag Sethiya).

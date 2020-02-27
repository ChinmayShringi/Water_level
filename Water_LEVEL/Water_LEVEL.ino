#include "FirebaseESP8266.h"
#include <ESP8266WiFi.h>
const int trigP = 16;  //D4 Or GPIO-2 of nodemcu
const int echoP = 5;  //D3 Or GPIO-0 of nodemcu

long duration;
int distance;

#define FIREBASE_HOST "test-8dd77.firebaseio.com"
#define FIREBASE_AUTH "TRDOW4Zlsjpu1NCScwaAiCVDdeZfAqa6NQs3KSSg"
#define WIFI_SSID "123"
#define WIFI_PASSWORD "1234567890"
FirebaseData firebaseData;
FirebaseJson json;

void setup()
{
 pinMode(trigP, OUTPUT);  // Sets the trigPin as an Output
 pinMode(echoP, INPUT);
  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  /*Firebase.reconnectWiFi(true);
  firebaseData.setBSSLBufferSize(1024, 1024);
  firebaseData.setResponseSize(1024);
  Firebase.setReadTimeout(firebaseData, 1000 * 60);
  Firebase.setwriteSizeLimit(firebaseData, "tiny");
  String path = "/Parking";
  Serial.println("------------------------------------");
  json.set("STAT1:",distance);
    if (Firebase.updateNode(firebaseData, path + "/Slot", json))
    {
      Serial.println("PASSED");
    }
    else
    {
      Serial.println("FAILED");
      Serial.println("REASON: " + firebaseData.errorReason());
      Serial.println("------------------------------------");
      Serial.println();
    }*/ 
}

void loop()
{
 digitalWrite(trigP, LOW);   // Makes trigPin low
 delayMicroseconds(2);       // 2 micro second delay 
 digitalWrite(trigP, HIGH);  // tigPin high
 delayMicroseconds(10);      // trigPin high for 10 micro seconds
 digitalWrite(trigP, LOW);   // trigPin low
 duration = pulseIn(echoP, HIGH);   //Read echo pin, time in microseconds
 distance= duration*0.034/2;        //Calculating actual/real distance
 Serial.print("Distance = ");        //Output distance on arduino serial monitor 
 Serial.println(distance);
 Firebase.reconnectWiFi(true);
  firebaseData.setBSSLBufferSize(1024, 1024);
  firebaseData.setResponseSize(1024);
  Firebase.setReadTimeout(firebaseData, 1000 * 60);
  Firebase.setwriteSizeLimit(firebaseData, "tiny");
  String path = "/WaterTank";
  Serial.println("------------------------------------");
  json.set("WaterLevel:",distance);
    if (Firebase.updateNode(firebaseData, path + "/Slot", json))
    {
      Serial.println("PASSED");
    }
    else
    {
      Serial.println("FAILED");
      Serial.println("REASON: " + firebaseData.errorReason());
      Serial.println("------------------------------------");
      Serial.println();
    }
delay(3000);             
}

# DigiWallets
An iOS app showing a list of MOCKED digital wallets and also the transactions made for those digital wallets.

# Architecture
The app is divided into 4 module.
1. The `CryptoLoader` is the most outer part of the app, which maintains the communication through Network
2. The `APILayer` is the next part after `CryptoLoader`. The `APILayer` converts the raw data into API based models.
3. The next part is the `iOS` which in isolation creates the Views to represent those raw data by converting them into corresponding view model.
4. Last is the `MyCryptoApp` which is the composer module. On this module we compose all the above three module to run the app.

```
                 _______________
                |  CryptoLoader |
                |_______________|
                       /|\
                        |
                        |
                 _______________
                |   APILayer    |
                |_______________|
                       /|\
                        |
                        |
                 _______________
                |      iOS      |
                |_______________|
                       /|\
                        |
                        |
                 _______________
                |  MyCryptoApp  |
                |_______________|
```


# Unit test
Except the `MyCryptoApp` all other modules are developed using TDD approach.

# Modules intorduction
- `CryptoLoader` and `APILayer` were first developed as mac based framework. Then the other platforms support were added. Netwroking and API based conversion is not iOS dependent. So making them mac based gives us the very quick feedback loop. As the test code runs on Mac.
  - `CryptoLoader` is focusing on Networking
  - `APILayer` is focusing on raw data conversion. `APILayer` converts the raw Data into API layer based model, so that the next model 'iOS` can digest/convert this model into its own model(ViewModel)
- `iOS` is the iOS based framework and concerntrates on the UI part. Select any of the simulator to run the test for this module. `iOS` was choosen a framework as it will give a lot faster feedback loop. Because to run the tests for `iOS` we will not need to run the app on the simulator.
- `MyCryptoApp` currently do not have any test. The plan was to add some UI tests for this module. However we can run this module on the simulator.



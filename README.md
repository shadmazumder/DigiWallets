# DigiWallets
An iOS app showing a list of MOCKED digital wallets and also the transactions made for those digital wallets.

# Architecture
The app is divided into 4 module.
1. The `CryptoLoader` is the most outer part of the app, which maintains the communication through Network
2. The `APILayer` is the next part after `CryptoLoader`. The `APILayer` converts the raw data into API based models.
3. The next part is the `iOS` which in isolation creates the Views to represent those raw data by converting them into corresponding view model.
4. Last is the `MyCryptoApp` which is the composer module. On this module we compose all the above three module to run the app.

Remote server <-- CryptoLoader <-- APILayer <-- iOS <-- MyCryptoApp

# Unit test
Except the `MyCryptoApp` all other modules are developed using TDD approach.

# Modules intorduction
`CryptoLoader` and `APILayer` are mac based framework. To run the test for those two module please select `My Mac` from the schema and run the tests on. As the code are not dependent on the `UIKit` we intentionally skipped to build those two module as iOS framework. Becuse the feedback loop is far more faster than the iOS based framework.

`iOS` is the iOS based framework and concerntrates on the UI part. Select any of the simulator to run the test for this module.

`MyCryptoApp` currently do not have any test. The plan was to add some UI tests for this module. However we can run this module on the simulator.



flyer.ly
========

Repository for flyer.ly

Automated Testing
=================

Installation
------------

1. Install Brew

   ```ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"```

2. Update Brew 

   ```brew update``` 

3. Install ImageMagick and Node

   ```brew install imagemagick node```

4. Install CoffeScript

   ```
   cd <Flyerly Directory>
   npm install coffee-script
   ```

5. Install Zucchini

   ```sudo gem install zucchini-ios```


Configuring Tests
-----------------

1. Build and run the latest code on iOS 5 Simulator, iOS 4 Simulator and iPhone / iPad device.
2. Make a copy of ```UITests\features\support\config.yml.default``` and name it ```UITests\features\support\config.yml```
3. Make sure the path for the app is correct for the simulators in ```UITests\features\support\config.yml```
4. Make sure the UDID is correct for the device attached in the device configuration

Running Tests
-------------

1. Run on iOS 5 (Simulator):

   ```ZUCCHINI_DEVICE="iPhone Simulator" zucchini run --reports-dir <directory for reports> UITests/features/<test to run>/```

2. Run on iOS 4 (Simulator):

   ```ZUCCHINI_DEVICE="iPhone Simulator 4" zucchini run --reports-dir <directory for reports> UITests/features/<test to run>/```
   
3. Run on Device:

   ```ZUCCHINI_DEVICE="iOS Device" zucchini run --reports-dir <directory for reports> UITests/features/<test to run>/``` 

Reports need to be emailed to the QA team


### Release History

http://appshopper.com/productivity/socialflyr

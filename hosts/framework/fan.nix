{ ... }:
{
  hardware.fw-fanctrl = {
    enable = true;
    config = {
      defaultStrategy = "flat";
      strategies.flat = {
        fanSpeedUpdateFrequency = 5;
        movingAverageInterval = 45;
        speedCurve = [
          {
            temp = 0;
            speed = 15;
          }
          {
            temp = 70;
            speed = 15;
          }
          {
            temp = 75;
            speed = 25;
          }
          {
            temp = 80;
            speed = 40;
          }
          {
            temp = 85;
            speed = 65;
          }
          {
            temp = 90;
            speed = 100;
          }
        ];
      };
    };
  };
}

#!/usr/bin/perl -w
# gestureListener.pl listens for pinch and swipe events
use strict;
use Time::HiRes();
use X11::GUITest qw( :ALL );

my @xHist = ();               # x coordinate history
my @yHist = ();               # y coordinate history
my @xHistThree = ();          # x coordinate history (three fingers)

my $lastTime = 0;             # time monitor for TouchPad event reset
my $eventTime = 0;            # ensure enough time has passed between events
my $eventString = "default";  # the event to execute
my $centerTouchPad = 3000;
my $openSt         = 1000;    # start of open pinch
my $openEn         = 500;     # end of open pinch
my $closeSt        = 1000;    # start of close pinch
my $closeEn        = 1000;    # end of close pinch

my $synCmd = qq{synclient TouchpadOff=1 -m 10};
my $currWind = GetInputFocus();
die "couldn't get input window" unless $currWind;
open(INFILE," $synCmd |") or die "can't read from synclient";

while( my $line  = <INFILE>)
{
  chomp($line);
  my(  $time, $x, $y, $z, $f ) = split " ", $line;
  next if( $time =~ /time/ ); #ignore header lines

  if( $time - $lastTime > 1 )
  {
    @xHist = ();
    @yHist = ();
    @xHistThree = ();
  }#if time reset

  $lastTime = $time;

  # three finger swipe detection
  if( $f eq "3" )
  {
    @xHist = ();
    @yHist = ();

    push @xHistThree, $x;

    if( @xHistThree > 10 )
    {
      my @srt = sort @xHistThree;
      my @revSrt = reverse sort @xHistThree;

      if( "@srt" eq "@xHistThree" )
      {
        # alt + right arrow - forward
        $eventString = "'%({RIG})";
      }elsif( "@revSrt" eq "@xHistThree" )
      { 
        # alt + left arrow - back
        $eventString = "'%({LEF})";
      }#if forward or backward

      @xHistThree= ();

    }#if more than 10 data points in 3 finger array
  }elsif( $f eq "2" || $f eq "1" )
  {
    # accept 1 or 2 finger entries as part of pinch section
    @xHistThree = ();

    push @xHist, $x;
    push @yHist, $y;

    if( @xHist > 50 )
    { 
      if( (getStrAvg(\@xHist) > $closeSt && getStrAvg(\@yHist) > $closeSt) &&
          (getEndAvg(\@yHist) < $closeEn && getEndAvg(\@yHist) < $closeEn) )
      { 
        # wide to narrow detected, now search for enough 'wiggle'

        my $tenX = 0;
        my $tenY = 0;
        for my $each( @xHist[40..49] ){ $tenX += $each }
        for my $each( @yHist[40..49] ){ $tenY += $each }
        $tenX = $tenX / 10;
        $tenY = $tenY / 10;

        my $diffX = 0;
        my $diffY = 0;
        for my $each( @xHist[40..49] ){ $diffX += abs( $each - $tenX ) }
        for my $each( @yHist[40..49] ){ $diffY += abs( $each - $tenY ) }

        # ctrl - decrease font size
        if( ($diffX+$diffY) > 80 ){ $eventString = "^({-})" }

        @xHist = ();
        @yHist = ();
        @xHistThree = ();

      }#if x and y in range

    }#if enough data for 50 close pinch detection

    #open pinch requires substantially fewer data points
    if( @xHist > 10 )
    {
      if( (getStrAvg(\@xHist) < $openSt && getStrAvg(\@yHist) < $openSt) &&
          (getEndAvg(\@yHist) > $openEn && getEndAvg(\@yHist) > $openEn) )
      {
        # ctrl + increase font size
        $eventString = "^({+})";

        @xHist = ();
        @yHist = ();
        @xHistThree = ();
      }#if absx and absy

    }#if enough data



  }else
  {
    # reset all data points, yes you can have 0 fingers at x,y
    @xHist = ();
    @yHist = ();
    @xHistThree = ();
  }# if not one or two or three fingers

  # only process one event per time window
  if( $eventString ne "default" )
  {
    if( abs(time - $eventTime) > 1 )
    {
      $eventTime = time;
      SendKeys( "$eventString");
    }#if enough time has passed
    $eventString = "default";
  }#if non default event

}#synclient line in

close(INFILE);


sub getStrAvg
{
  my $arrRef = $_[0];
  my $val = (@$arrRef[0] + @$arrRef[1] + @$arrRef[2]) / 3;
  $val = abs( $val - $centerTouchPad );
  return($val);
}#getStrAvg

sub getEndAvg
{
  my $arrRef = $_[0];
  my $val = (@$arrRef[@$arrRef-3] + @$arrRef[@$arrRef-2] +
               @$arrRef[@$arrRef-1]) / 3;
  $val = abs( $val - $centerTouchPad );
  return($val);
}#getEndAvg


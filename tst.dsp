import("stdfaust.lib");
//import("basics.lib");

// import("/home/bart/source/faustlibraries/stdfaust.lib");
// import("/home/bart/source/faustlibraries/basics.lib");

// ma = library("/home/bart/source/faustlibraries/maths.lib");

maxN = 2;
// maxN = 28;
INF = 99999;
//maxMedianNr = pow(3,3):int;
maxMedianNr = 7;
maxMedianNr5 = 25;
maxMeanNr = pow(2,int2nrOfBits(maxMedianNr)) ;
//maxMedianNr = 177147;
//maxMedianNr = pow(3,3);
process =
  //int(pow(3,ceil(log(80)/log(3)))/3);
  compare;
compare =
        signal<:
        (slidingMedianOfMedians(maxMedianNr):meter1)
       ,(ba.slidingMeanN(maxMedianNr,maxMeanNr):meter2)
;

signal = no.noise*hslider("noise level", 0, 0, 1, 0.01)+hslider("DC", 0, -1, 1, 0.01)+(hslider("osc level", 0, 0, 1, 0.01)*os.osc(hslider("freq", 110, 1, 440, 1)));
meter1 = (_<:(_, ((vbargraph("Median3", -1, 1)))):attach);
meter2 = (_<:(_, ((vbargraph("Mean", -1, 1)))):attach);


// my_slidingReduce(min,n,pow(2,maxN),INF);
// ba.slidingMinN(n,pow(2,maxN));
// _<: par(i, maxN, ba.slidingMinN(n,pow(2,i+1)) :control(i==N)) :>_;
N = hslider("N", 0, 0, maxN, 1):int;
n= hslider("n", 1, 1, pow(2,maxN), 1):int;
// par(i,5,os.osc(440*(i+1)) : control(algorithm == i)) :> _;
// algorithm = nentry("oct",0,0,4,1) : int;

// par(i,5,no.noise : control(algorithm == i)) :> _;
// algorithm = nentry("oct",0,0,4,1) : int;


// par(i, 3, os.osc(440*(i+1):control(i == hslider("controll", 0, 0, 3, 1):int)));
// (os.osc(440),os.osc(880)):control(hslider("control", 1, 0, 1, 1));
//dx.dx7_ui;
// os.osc(440),_*hslider("gain", 1, 0, 1, 0.001);


slidingMedianOfMedians =
  case {
    (1,x) => x;
    (2,x) => (x+x')/2;  // hey, it's better than picking one!
    (n,x) =>
(slidingMedianOfMedians(groupsize,x), slidingMedianOfMedians(groupsize,x)@groupsize, slidingMedianOfMedians(n-(2*groupsize),x)@(groupsize*2))
//(slidingMedianOfMedians(groupsizeB,x), slidingMedianOfMedians(groupsizeS,x)@groupsizeB, slidingMedianOfMedians(n-(groupsizeB+groupsizeS),x)@(groupsizeB+groupsizeS))
    : MedianOfMedians3 with {
      //groupsize = int(n/3);
      groupsize = int(pow(3,floor(log(n)/log(3)))/3);
      //groupsizeB = int(pow(3,ceil(log(n)/log(3)))/3);
      //groupsizeS = int(pow(3,floor(log(n)/log(3)))/3);
      MedianOfMedians3(x0,x1,x2) =
        select3(sell,x0,x1,x2) with {
        sell =
          (  ( ((x1>=x0) & (x1<=x2)) | ((x1>=x2) & (x1<=x0))))
+       (2*( ((x2> x1) & (x2< x0)) | ((x2> x0) & (x2< x1)))) ;
        };
    };
  };

slidingMedianOfMedians5 =
  case {
    (1,x) => x;
    (2,x) => (x+x')/2;  // hey, it's better than picking one!
    (n,x) =>
(slidingMedianOfMedians5(n/3,x), slidingMedianOfMedians5(n/3,x)@(n/3), slidingMedianOfMedians5(n/3,x)@(n/3*2))
    : MedianOfMedians3 with {
      MedianOfMedians3(x0,x1,x2) =
        select3(sell,x0,x1,x2) with {
      sell =
        (  ( ((x1>=x0) & (x1<=x2)) | ((x1>=x2) & (x1<=x0))))
+       (2*( ((x2> x1) & (x2< x0)) | ((x2> x0) & (x2< x1)))) ;
        };
    };
  };
// slidingMedianOfMedians(3) = MedianOfMedians3(x0,x1,x2);
//slidingMedianOfMedians(3) =



my_slidingReduce(op,N,maxN,disabledVal,x) =
  par(i,maxNrBits,fixedDelayOp(pow2(i),x)@sumOfPrevBlockSizes(N,maxN,i)
                  : useVal(i)) : combine(maxNrBits)
with {

  // Apply <op> to the last <N> values of <x>, where <N> is fixed
  fixedDelayOp = case {
                   (1,x) => x;
                   (N,x) => op(fixedDelayOp(N/2,x), fixedDelayOp(N/2,x)@(N/2));
  };

  // The sum of all the sizes of the previous blocks
  sumOfPrevBlockSizes(N,maxN,0) = 0;
  sumOfPrevBlockSizes(N,maxN,i) = (subseq((allBlockSizes(N,maxN)),0,i):>_);
  allBlockSizes(N,maxN) = par(i, maxNrBits, (pow2(i)) * isUsed(i));
  maxNrBits = int2nrOfBits(maxN);

  // Apply <op> to <N> parallel input signals
  combine(2) = op;
  combine(N) = op(combine(N-1),_);

  // Decide wether or not to use a certain value, based on N
  // Basically only the second <select2> is needed,
  // but this version also works for N == 0
  // 'works' in this case means 'does the same as reduce'
  useVal(i) =
    enable(isUsed(i) | ((i==0) & (N==0))) <: select2(
      (i==0) & (N==0),
      select2(isUsed(i), disabledVal,_),
      _
    );

  // useVal(i) =
  //     select2(isUsed(i), disabledVal,_);
  isUsed(i) = take(i+1,(int2bin(N,maxN)));
  pow2(i) = 1<<i;
  // same as:
  // pow2(i) = int(pow(2,i));
  // but in the block diagram, it will be displayed as a number, instead of a formula

  // convert N into a list of ones and zeros
  int2bin(N,maxN) = par(j,int2nrOfBits(maxN),int(floor(N/(pow2(j))))%2);
};
// calculate how many ones and zeros are needed to represent maxN
int2nrOfBits(0) = 0;
int2nrOfBits(maxN) = int(floor(log(maxN)/log(2))+1);

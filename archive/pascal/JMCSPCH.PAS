PROGRAM testSpeech;

Uses
    speech;
{
 This is the Turbo Pascal include-file for the speech driver.  The
 parameter S must be a character string containing valid phoneme codes:

   CODE   SOUND  (capitalized in sample word)
   ----   -----
    A     mAke   = m-A-k
    AE    bAt    = b-AE-t
    AH    cAr    = k-AH-r
    AW    dOg    = d-AW-g
    B     Bat    = B-ae-t
    CH    CHeese = CH-ee-z
    D     Dog    = D-aw-g
    EE    bE     = b-EE
    EH    bEt    = b-EH-t
    F     raFt   = r-ae-F-t
    G     Go     = G-oh
    H     Hive   = H-i-v
    I     tIme   = t-I-m
    IH    sIt    = s-IH-t
    J     Jet    = J-eh-t
    K     Kill   = K-ih-l
    L     Love   = L-uh-v
    M     Map    = M-ae-p
    N     Nab    = N-ae-b
    OH    gO     = g-OH
    OO    gOO    = g-OO
    P     Pat    = P-ae-t
    R     Rat    = R-ae-t
    S     Sat    = S-ae-t
    SH    SHe    = SH-ee
    T     Tap    = T-ae-p
    TH    THin   = TH-ih-n
    TZ    THis   = TZ-ih-s
    U     wOrd   = w-U-r-d
    UH    bUt    = b-UH-t
    V     Vat    = V-ae-t
    W     With   = W-ih-th
    WH    WHich  = WH-ih-ch
    Y     Yes    = Y-eh-s
    Z     Zap    = Z-ae-p
    ZH    viSion = v-ih-ZH-eh-n
    -     inter-phoneme separator
   space  inter-word pause
}

type
  SpeechString = string[255];

procedure Speech(S: SpeechString);
  external 'SPEECH.BIN';

{ This procedure speaks the positive integers 1 through 32768. }
procedure NumSpeech(N: integer);
  begin
    case N of
      01:           Speech(' wh-uh-n');
      02:           Speech(' t-oo');
      03:           Speech(' th-r-ee');
      04:           Speech(' f-oh-r');
      05:           Speech(' f-i-v');
      06:           Speech(' s-ih-k-s');
      07:           Speech(' s-eh-v-eh-n');
      08:           Speech(' a-ee-t');
      09:           Speech(' n-i-n');
      10:           Speech(' t-eh-n');
      11:           Speech(' eh-l-eh-v-eh-n');
      12:           Speech(' t-w-eh-l-v');
      13:           Speech(' th-ih-r-t-ee-n');
      14:           Speech(' f-oh-r-t-ee-n');
      15:           Speech(' f-ih-f-t-ee-n');
      16:           Speech(' s-ih-k-s-t-ee-n');
      17:           Speech(' s-eh-v-eh-n-t-ee-n');
      18:           Speech(' a-ee-t-t-ee-n');
      19:           Speech(' n-i-n-t-ee-n');
      20..29:       begin
                      Speech(' t-w-eh-n-t-ee');
                      NumSpeech(N - 20);
                    end;
      30..39:       begin
                      Speech(' th-ih-r-t-ee');
                      NumSpeech(N - 30);
                    end;
      40..49:       begin
                      Speech(' f-oh-r-t-ee');
                      NumSpeech(N - 40);
                    end;
      50..59:       begin
                      Speech(' f-ih-f-t-ee');
                      NumSpeech(N - 50);
                    end;
      60..69:       begin
                      Speech(' s-ih-k-s-t-ee');
                      NumSpeech(N - 60);
                    end;
      70..79:       begin
                      Speech(' s-eh-v-eh-n-t-ee');
                      NumSpeech(N - 70);
                    end;
      80..89:       begin
                      Speech(' a-ee-t-ee');
                      NumSpeech(N - 80);
                    end;
      90..99:       begin
                      Speech(' n-i-n-t-ee');
                      NumSpeech(N - 90);
                    end;
      100..999:     begin
                      NumSpeech(N div 100);
                      Speech(' h-uh-n-d-r-eh-d');
                      NumSpeech(N mod 100);
                    end;
      1000..maxint: begin
                      NumSpeech(N div 1000);
                      Speech(' th-aw-u-s-ae-n-d');
                      NumSpeech(N mod 1000);
                    end;
    end;
  end {NumSpeech};

BEGIN
     NumSpeech(1);
     Numspeech(2);
     numspeech(3);
END.
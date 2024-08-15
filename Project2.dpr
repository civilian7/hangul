program Project2;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Generics.Collections;

type
  THangul = class
  strict private
  {$REGION 'CONSTS'}
    const
      // https://www.unicode.org/charts/PDF/U1100.pdf
      CHOSUNG: array[0..1, 0..18] of string = (
        ('ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ',
         'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'),
        ('r', 'R', 's', 'e', 'E', 'f', 'a', 'q', 'Q',
         't', 'T', 'd', 'w', 'W', 'c', 'z', 'x', 'v', 'g')
      );
      JUNGSUNG: array[0..1, 0..20] of string = (
        ('ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ',
         'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ'),
        ('k', 'o', 'i', 'O', 'j', 'p', 'u', 'P', 'h', 'hk',
         'ho', 'hl', 'y', 'n', 'nj', 'np', 'nl', 'b', 'm', 'ml', 'l')
      );
      JONGSUNG: array[0..1, 0..27] of string = (
        ('', 'ㄱ', 'ㄲ', 'ᆪ', 'ᆫ', 'ᆬ', 'ᆭ', 'ㄷ', 'ㄹ', 'ᆰ', 'ᆱ', 'ᆲ', 'ᆳ', 'ᆴ',
         'ᆵ', 'ᆶ', 'ㅁ', 'ㅂ', 'ᆹ', 'ᆺ', 'ᆻ', 'ᆼ', 'ᆽ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'),
        ('', 'r', 'R', 'rt', 's', 'sw', 'sg', 'e', 'f', 'fr', 'fa', 'fq', 'ft', 'fx',
         'fv', 'fg', 'a', 'q', 'qt', 't', 'T', 'd', 'w', 'c', 'z', 'x', 'v', 'g')
      );
  {$ENDREGION}
  public
    class function GetChosung(const AValue: string): string; static;
    class function ToEnglish(const AValue: string): string; static;
    class function Unpack(const AValue: string): string; static;
  end;

{ THangul }

class function THangul.GetChosung(const AValue: string): string;
begin
  Result := '';
  for var i := 1 to Length(AValue) do
  begin
    var LChar := AValue[i];
    if WORD(LChar) > $AC00 then
    begin
      var LIndex := WORD(LChar) - $AC00;
      var LJongsung := LIndex mod 28;
      var LJungsung := ((LIndex - LJongsung) div 28) mod 21;
      var LChosung  := ((LIndex - LJongsung) div 28) div 21;

      Result := Result + CHOSUNG[0, LChosung];
    end;
  end;
end;

class function THangul.ToEnglish(const AValue: string): string;
begin
  result := '';
  for var i := 1 to Length(AValue) do
  begin
    var LChar := AValue[i];
    if WORD(LChar) > $AC00 then
    begin
      var LIndex := WORD(LChar) - $AC00;
      var LJongsung := LIndex mod 28;
      var LJungsung := ((LIndex - LJongsung) div 28) mod 21;
      var LChosung  := ((LIndex - LJongsung) div 28) div 21;

      Result := Result + CHOSUNG[1, LChosung] + JUNGSUNG[1, LJungsung] + JONGSUNG[1, LJongsung];
    end
    else
      Result := Result + LChar;
  end;
end;

class function THangul.Unpack(const AValue: string): string;
begin
  Result := '';
  for var i := 1 to Length(AValue) do
  begin
    var LChar := AValue[i];
    if WORD(LChar) > $AC00 then
    begin
      var LIndex := WORD(LChar) - $AC00;
      var LJongsung := LIndex mod 28;
      var LJungsung := ((LIndex - LJongsung) div 28) mod 21;
      var LChosung  := ((LIndex - LJongsung) div 28) div 21;

      Result := Result + CHOSUNG[0, LChosung] + JUNGSUNG[0, LJungsung] + JONGSUNG[0, LJongsung];
    end
    else
      Result := Result + LChar;
  end;
end;

function MakeHangul(const ACho, AJung, AJong: Integer): string;
begin
  Result := string(Char($AC00 + ACho * 21 * 28 + AJung * 28 + AJong));
end;

function engtohan(const AValue: string): string;
const
  ENG_KEY   = 'rRseEfaqQtTdwWczxvgkoiOjpuPhynbml';
  KOR_KEY   = 'ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎㅏㅐㅑㅒㅓㅔㅕㅖㅗㅛㅜㅠㅡㅣ';
  CHO_DATA  = 'ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ';
  JUNG_DATA = 'ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ';
  JONG_DATA = 'ㄱㄲㄳㄴㄵㄶㄷㄹㄺㄻㄼㄽㄾㄿㅀㅁㅂㅄㅅㅆㅇㅈㅊㅋㅌㅍㅎ';
begin
  var LResult: string := '';
  if AValue.Length = 0 then
    Exit(LResult);

  var LCho := 0;
  var LJung := 0;
  var LJong := 0;

  for var i := 1 to AValue.Length do
  begin
    var LChar := AValue[i];
    var LIndex := Pos(LChar, ENG_KEY);

    if (LIndex = 0) then
      LIndex := Pos(LowerCase(LChar), ENG_KEY);

    if (LIndex = 0) then
    begin
      if (LCho <> 0) then
      begin
        if (LJung <> 0) then
          LResult := LResult + Makehangul(LCho, LJung, LJong)
        else
          LResult := LResult + CHO_DATA[LCho];
      end else begin
        if (LJung <> 0) then
          LResult := LResult + JUNG_DATA[LJung]
        else
        if (LJong <> 0) then
          LResult := LResult + JONG_DATA[LJong];
      end;

      LCho := 0;
      LJung := 0;
      LJong := 0;
      LResult := LResult + LChar;
    end
    else if (LIndex <= 19) then
    begin
      if (LJung <> 0) then
      begin
        if (LCHo = 0) then
        begin
          LResult := LResult + JUNG_DATA[LJung];
          LJung := 0;
          LCho := Pos(KOR_KEY[LIndex], CHO_DATA);
        end
        else
        begin
          if (LJong = 0) then
          begin
            LJong := Pos(KOR_KEY[LIndex], JONG_DATA);
            if (LJong = 0) then
            begin
              LResult := LResult + MakeHangul(LCho, LJung, LJong);
              LCho := Pos(KOR_KEY[LIndex], CHO_DATA);
              LJung := 0;
            end
            else if (LJong = 1) and (LIndex = 10) then // ㄳ
              LJong := 2
            else if (LJong = 4) and (LIndex = 13) then // ㄳ
              LJong := 5
            else if (LJong = 4) and (LIndex = 19) then // ㄳ
              LJong := 6
            else if (LJong = 8) and (LIndex = 1) then // ㄳ
              LJong := 9
            else if (LJong = 8) and (LIndex = 7) then // ㄳ
              LJong := 10
            else if (LJong = 8) and (LIndex = 8) then // ㄳ
              LJong := 11
            else if (LJong = 8) and (LIndex = 10) then // ㄳ
              LJong := 12
            else if (LJong = 8) and (LIndex = 17) then // ㄳ
              LJong := 13
            else if (LJong = 8) and (LIndex = 18) then // ㄳ
              LJong := 14
            else if (LJong = 8) and (LIndex = 19) then // ㄳ
              LJong := 15
            else if (LJong = 17) and (LIndex = 10) then // ㄳ
              LJong := 18
            else
            begin
              LResult := LResult + MakeHangul(LCho, LJung, LJong);
              LCho := Pos(KOR_KEY[LIndex], CHO_DATA);
              LJung := 0;
              LJong := 0;
            end;
          end;
        end;
      end
      else
      begin
        if (LCho = 0) then
        begin
          if (LJong <> 0) then
          begin
            LResult := LResult + MakeHangul(LCho, LJung, LCho);
            LJong := 0;
          end;
          LCho := Pos(KOR_KEY[LIndex], CHO_DATA);
        end else if (LCho = 1) and (LIndex = 10) then
        begin
          LCho := 0;
          LJong := 3;
        end
        else if (LCho = 3) and (LIndex = 13) then
        begin
          LCho := 0;
          LJong := 5;
        end
        else if (LCho = 3) and (LIndex = 19) then
        begin
          LCho := 0;
          LJong := 6;
        end
        else if (LCho = 6) and (LIndex = 1) then
        begin
          LCho := 0;
          LJong := 9;
        end
        else if (LCho = 6) and (LIndex = 7) then
        begin
          LCho := 0;
          LJong := 10;
        end
        else if (LCho = 6) and (LIndex = 8) then
        begin
          LCho := 0;
          LJong := 11;
        end
        else if (LCho = 6) and (LIndex = 10) then
        begin
          LCho := 0;
          LJong := 12;
        end
        else if (LCho = 6) and (LIndex = 17) then
        begin
          LCho := 0;
          LJong := 13;
        end
        else if (LCho = 6) and (LIndex = 18) then
        begin
          LCho := 0;
          LJong := 14;
        end
        else if (LCho = 6) and (LIndex = 19) then
        begin
          LCho := 0;
          LJong := 15;
        end
        else if (LCho = 8) and (LIndex = 10) then
        begin
          LCho := 0;
          LJong := 19;
        end
        else
        begin
          LResult := LResult + CHO_DATA[LCho];
          LCho := Pos(KOR_KEY[LIndex], CHO_DATA);
        end;
      end;
    end
    else
    begin
      if (LJong <> 0) then
      begin
        var LNewCho: Integer;

        if (LJong = 3) then
        begin
          LJong := 1;
          LNewCho := 10;
        end else if (LJong = 5) then
        begin
          LJong := 4;
          LNewCho := 13;
        end else if (LJong = 9) then
        begin
          LJong := 8;
          LNewCho := 1;
        end else if (LJong = 10) then
        begin
          LJong := 8;
          LNewCho := 7;
        end else if (LJong = 11) then
        begin
          LJong := 8;
          LNewCho := 8;
        end else if (LJong = 12) then
        begin
          LJong := 9;
          LNewCho := 10;
        end else if (LJong = 13) then
        begin
          LJong := 8;
          LNewCho := 17;
        end else if (LJong = 14) then
        begin
          LJong := 8;
          LNewCho := 18;
        end else if (LJong = 15) then
        begin
          LJong := 8;
          LNewCho := 19;
        end else if (LJong = 18) then
        begin
          LJong := 17;
          LNewCho := 10;
        end else begin
          LNewCho := Pos(KOR_KEY[LIndex], CHO_DATA);
          LJong := 0;
        end;

        if (LCho <> 0) then
          LResult := LResult + MakeHangul(LCho, LJung, LJong)
        else
          LResult := LResult + JONG_DATA[LJong];

        LCho := LNewCho;
        LJung := 0;
        LJong := 0;
      end;

      if (LJung = 0) then
        LJung := Pos(KOR_KEY[LIndex], JUNG_DATA)
      else if (LJung = 9) and (LIndex = 20) then
        LJung := 10
      else if (LJung = 9) and (LIndex = 21) then
        LJung := 11
      else if (LJung = 9) and (LIndex = 33) then
        LJung := 12
      else if (LJung = 14) and (LIndex = 24) then
        LJung := 15
      else if (LJung = 14) and (LIndex = 25) then
        LJung := 16
      else if (LJung = 14) and (LIndex = 33) then
        LJung := 17
      else if (LJung = 19) and (LIndex = 33) then
        LJung := 20
      else begin
        if (LCho <> 0) then
        begin
          LResult := LResult + MakeHangul(LCho, LJung, LJong);
          LCho := 0;
        end
        else
        begin
          LResult := LResult + JUNG_DATA[LJung];
        end;

        LJung := 0;
        LResult := LResult + KOR_KEY[LIndex+1];
      end;
    end;
  end;

  if (LCho <> 0) then
  begin
    if (LJung <> 0) then
      LResult := LResult + MakeHangul(LCho, LJung, LJong)
    else
      LResult := LResult + CHO_DATA[LCho];
  end
  else
  begin
    if (LJung <> 0) then
      LResult := LResult + JUNG_DATA[LJung]
    else
    begin
      if (LJong <> 0) then
        LResult := LResult + JONG_DATA[LJong];
    end;
  end;

  Result := LResult;
end;

begin
  var L2 := engtohan('gksrnrepfvkdlehdghghl epfakekd');

  WriteLn(L2);
  Readln;
end.


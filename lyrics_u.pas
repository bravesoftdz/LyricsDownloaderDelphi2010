unit lyrics_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtrls, SHDocVw, ActiveX, ComCtrls;

type
  TForm2 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    WebBrowser1: TWebBrowser;
    Edit2: TEdit;
    RichEdit1: TRichEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  wb:Twebbrowser;
  filename:String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure Save(WB: TWebBrowser; const FileName: string);
var
  PersistStream: IPersistStreamInit;
  Stream: IStream;
  FileStream: TFileStream;
  b:boolean;
begin
b:=true;
while b do
begin
  if assigned(wb.Document) then
  b:=false
  else
  b:=true;
  application.ProcessMessages;
end;

 { if not Assigned(WB.Document) then
  begin
    ShowMessage('Document not loaded!');
    Exit;
  end;
  }

  PersistStream := WB.Document as IPersistStreamInit;
  FileStream := TFileStream.Create(FileName, fmCreate);
  try
    Stream := TStreamAdapter.Create(FileStream, soReference) as IStream;
    if Failed(PersistStream.Save(Stream, True)) then
      ShowMessage('SaveAs HTML fail!');
  finally
    FileStream.Free;
  end;
end;

procedure TForm2.Button1Click(Sender: TObject);
var
  Rawartist: string;
  RawName: string;
  posSpace: Integer;
  tFile: TextFile;
  ssearch,sline: String;
  Browser: TWebBrowser;
  i, b: Integer;
  Dir:TsearchRec;
  aFile:textfile;
    //tFile: TextFile;
  RawHtml: array [1 .. 80000] of String;
  Count ,Start, Finish: Integer;
  //sLine: String;
  posBreak: Integer;
  song: Array [1 .. 50000] of String;
begin
  Rawartist := Edit2.Text;
  RawName := Edit1.Text;
  // remove spaces;
  for i := 1 to length(Name) do
  begin
    for b := 1 to length(Name) do
    begin
      posSpace := Pos(' ', RawName);
      delete(RawName, posSpace, 1);
    end;
  end;
  for i := 1 to length(Rawartist) do
  begin
    for b := 0 to length(Rawartist) do
    begin
      posSpace := Pos(' ', Rawartist);
      delete(Rawartist, posSpace, 1);
    end;
  end;
  //
  ssearch := 'https://www.azlyrics.com/lyrics/' + lowercase(Rawartist)
    + '/' + lowercase(RawName) + '.html';
   filename:=lowercase(rawartist)+lowercase(RawName)+'.txt';
   wb:=Twebbrowser.Create(form2);
   wb.Navigate(ssearch);
   Save(Wb, './Lyrics/'+filename);
  //WebBrowser1.Navigate(ssearch);

  ///////////////////////////////


  richedit1.Lines.Clear;
  Count := 0;
  i := 0;
  b := 0;
  AssignFile(tFile, './Lyrics/'+filename);
  reset(tFile);
  while NOt EOF(tFile) do
  begin
    inc(Count);
    ReadLn(tFile, sLine);
    RawHtml[Count] := sLine;
  end;
try
  // Find start
  for i := 1 to Count do
  begin
    if RawHtml[i] =
      '<!-- Usage of azlyrics.com content by any third-party lyrics provider is prohibited by our licensing agreement. Sorry about that. -->' then
    begin
      Start := i + 1;
    end;
  end;
  // Find Finish
  for i := 1 to Count do
  begin
    if RawHtml[i] = '<!-- MxM banner -->' then
    begin
      Finish := i - 5;
    end;
  end;
  Closefile(tFile);
  for i := Start to Finish do
  begin
    inc(b);
    song[b] := RawHtml[i];
  end;
  for i := 1 to b do
  begin
    posBreak := Pos('<br>', song[i]);
    sLine := song[i];
    delete(sLine, posBreak, 4);
    richedit1.Lines.Add(sLine);
  end;
except
showmessage('Oops! Looks like the programmer is an idiot.');
end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
webbrowser1.Visible:=False;
end;

end.

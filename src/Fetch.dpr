program Fetch;

uses
  Forms,
  FetchMain in 'FetchMain.pas' {FetchForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFetchForm, FetchForm);
  Application.Run;
end.

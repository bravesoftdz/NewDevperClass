unit unit3;

interface

uses
  System.SysUtils, System.Classes, Data.DBXInterBase, Data.DB,
  Datasnap.DBClient, SimpleDS, Data.SqlExpr, Data.FMTBcd;

type
  TDM = class(TDataModule)
    employee: TSimpleDataSet;
    empSource: TDataSource;

    partSource: TDataSource;

    empView: TSQLQuery;
    insertPro: TSQLQuery;
     part: TSimpleDataSet;
    proSource: TDataSource;
    project: TSimpleDataSet;
    partView: TSQLQuery;
    SQLConnection1: TSQLConnection;
    proEmp: TSimpleDataSet;
    proEmpSource: TDataSource;
    delete: TSQLQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.

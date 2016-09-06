unit Utils.MD5;

interface

uses IdHashMessageDigest, idHash;

type
  TMD5 = class
  public
    class function Hash(AValue: string): string;
  end;

implementation

{ TMD5 }

class function TMD5.Hash(AValue: string): string;
var
  idmd5: TIdHashMessageDigest5;
  hash : T4x4LongWordRecord;
begin
  Result := '';

  idmd5 := TIdHashMessageDigest5.Create;
  try
    Result := idmd5.HashStringAsHex(AValue);
  finally
    idmd5.Free;
  end;
end;

end.

Codeunit 70102 "Kim Chui Algorithm"
{
    procedure KimChuiAlgorithm()
    var
        Base64Convert: Codeunit "Base64 Convert";
        Client: HttpClient;
        RequestHeaders: HttpHeaders;
        ResponseMessage: HttpResponseMessage;
        AuthString: Text;
        ResponseText: Text;
        Comply: Boolean;
        jObj: JsonObject;
        jToken: JsonToken;
        BawalLumabas: Boolean;
        Submitted: Boolean;
        PwedengLumabas: Boolean;
    begin
        Client.DefaultRequestHeaders().Add('Authorization', STRSUBSTNO('Basic %1', Base64Convert.ToBase64(STRSUBSTNO('%1:%2', 'ABSCBN', 'N02Sh4tD0wn!'))));
        Client.Get('https://news.abs-cbn.com/live', ResponseMessage);
        Comply := ResponseMessage.IsSuccessStatusCode();

        IF NOT Comply then begin
            Client.DefaultRequestHeaders().Add('Authorization', STRSUBSTNO('Basic %1', Base64Convert.ToBase64(STRSUBSTNO('%1:%2', '', ''))));
            Client.Get('http://ntc.gov.ph/wp-content/uploads/2020/broadcast/?firm=abscbn', ResponseMessage);
            ResponseMessage.Content().ReadAs(ResponseText);
            jObj.ReadFrom(ResponseText);
            jObj.SelectToken('license', jToken);

            BawalLumabas := (jToken.AsValue().AsText() = 'EXPIRED') And (NOt Comply);
            while Not PwedengLumabas do begin
                jObj.Get('Lumabas', jToken);
                BawalLumabas := BawalLumabas and (jToken.AsValue().AsBoolean() = true);
                jObj.Get('Sumbitted', jToken);
                Submitted := jToken.AsValue().AsBoolean();
                PwedengLumabas := (Submitted and Comply and (NOT BawalLumabas))
            end;
        end;
    end;
}
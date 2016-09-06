inherited FPrincipal: TFPrincipal
  Caption = 'FPrincipal'
  FormStyle = fsMDIForm
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  ExplicitTop = 8
  PixelsPerInch = 96
  TextHeight = 13
  object tbPrincipal: TdxTabbedMDIManager
    Active = True
    TabProperties.CloseButtonMode = cbmEveryTab
    TabProperties.CloseTabWithMiddleClick = True
    TabProperties.CustomButtons.Buttons = <>
    TabProperties.MultiLine = True
    Left = 32
    Top = 128
  end
end

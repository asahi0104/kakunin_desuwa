using namespace System.Windows.Forms
Add-Type -Assembly System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
# 手順ファイル
# Shiftキーを押しながらファイルを右クリック、パスのコピーで取得可能
$procedure_file = "X:\SrC\kakunin_desuwa\手順.txt"

# ファイルが無かったらエラー
if ( -not (Test-Path $procedure_file )) {
  [System.Windows.Forms.MessageBox]::Show("手順ファイルが見つかりません！$procedure_file", "エラー！","OK","Error","button1") > $null
  exit
}

# 手順ファイルの中身取得
$empty_check = $(Get-Content $procedure_file -Encoding UTF8| Select-String "^#" -NotMatch | Select-String "^\s*$" -NotMatch)

# 中身が空か確認
if([String]::IsNullOrEmpty($empty_check.Insert)){
  [System.Windows.Forms.MessageBox]::Show("ファイルが空か、全てコメントアウトされています", "エラー！","OK","Error","button1") > $null
  exit
}

# フォーム定義
$form = New-Object Windows.Forms.Form
$form.TopMost = $True

# 手順ファイルを出力
foreach ($procedure in $(Get-Content $procedure_file -Encoding UTF8| Select-String "^#" -NotMatch | Select-String "^\s*$" -NotMatch)){
  # カンマ区切りで分割
  $tmp = $procedure.ToString() 
  $tmp = $tmp.Split(",")

  # 各変数へ格納
  $number = $tmp[0] # 手順番号
  $title  = $tmp[1] # タイトル
  $text   = $tmp[2] # 本文
 
  $return = [Windows.Forms.MessageBox]::Show($form,"手順$number`r`n$text`r`n`r`n処理を続行しますか？","$title","YesNo","Question")

  if ($return -eq "Yes") {
    Write-Host "" -NoNewline
  } else {
    $return = [Windows.Forms.MessageBox]::Show($form,"処理を中断します","いいえが押下されました","OK","Information")

    exit
  }
}

Pause 100
# KOA Filo Servis - Kullanım Kılavuzu PDF Oluşturucu
# Gereksinim: Pandoc (https://pandoc.org/installing.html) + MiKTeX/tinytex
# Ya da sadece Word çıktısı için yalnızca Pandoc yeterlidir.

$input  = Join-Path $PSScriptRoot "KOAFiloServis_KullanımKılavuzu.md"
$outDocx = Join-Path $PSScriptRoot "KOAFiloServis_KullanımKılavuzu.docx"
$outPdf  = Join-Path $PSScriptRoot "KOAFiloServis_KullanımKılavuzu.pdf"
$outHtml = Join-Path $PSScriptRoot "KOAFiloServis_KullanımKılavuzu.html"

# Pandoc kurulu mu kontrol et
if (-not (Get-Command pandoc -ErrorAction SilentlyContinue)) {
    Write-Host "⚠  Pandoc bulunamadı." -ForegroundColor Yellow
    Write-Host "   Kurulum: https://pandoc.org/installing.html" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   Alternatif: Word ile açmak için ---> $outDocx" -ForegroundColor Green
    exit 1
}

Write-Host "📄 Word (docx) oluşturuluyor..." -ForegroundColor Cyan
pandoc $input -o $outDocx `
    --from=markdown `
    --to=docx `
    --toc `
    --highlight-style=tango
Write-Host "   ✅ $outDocx" -ForegroundColor Green

Write-Host "🌐 HTML oluşturuluyor..." -ForegroundColor Cyan
pandoc $input -o $outHtml `
    --from=markdown `
    --to=html5 `
    --standalone `
    --toc `
    --metadata title="KOA Filo Servis Kullanım Kılavuzu" `
    --css="https://cdn.jsdelivr.net/npm/bootstrap@5.3/dist/css/bootstrap.min.css"
Write-Host "   ✅ $outHtml" -ForegroundColor Green

# PDF - LaTeX gerektirir
try {
    Write-Host "📑 PDF oluşturuluyor (LaTeX gerekli)..." -ForegroundColor Cyan
    pandoc $input -o $outPdf `
        --from=markdown `
        --to=pdf `
        --toc `
        --pdf-engine=xelatex `
        -V "mainfont=Arial" `
        -V "geometry:margin=2cm" `
        -V "lang=tr"
    Write-Host "   ✅ $outPdf" -ForegroundColor Green
} catch {
    Write-Host "   ⚠  PDF oluşturulamadı (LaTeX kurulu değil)." -ForegroundColor Yellow
    Write-Host "   💡 Word dosyasını ($outDocx) açıp 'Farklı Kaydet → PDF' ile PDF'e çevirebilirsiniz." -ForegroundColor Cyan
}

Write-Host ""
Write-Host "✅ İşlem tamamlandı. Dosyalar: $PSScriptRoot" -ForegroundColor Green

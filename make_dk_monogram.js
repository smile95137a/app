// Crop the crown+D portion from dk_logo.png and build the header circle icon
const sharp = require('sharp');
const path = require('path');
const OUT = path.join(__dirname, 'assets', 'images');

async function main() {
  const SIZE = 200;

  // ── 1. Crop left 28% of dk_logo.png → that area = crown above D ──
  const { data: logoData, info: logoInfo } = await sharp(path.join(OUT, 'dk_logo.png'))
    .ensureAlpha()
    .raw()
    .toBuffer({ resolveWithObject: true });

  const cropW = Math.floor(logoInfo.width * 0.18);
  const cropH = logoInfo.height;

  // Extract left portion pixel by pixel
  const croppedBuf = Buffer.alloc(cropW * cropH * 4);
  for (let y = 0; y < cropH; y++) {
    for (let x = 0; x < cropW; x++) {
      const si = (y * logoInfo.width + x) * 4;
      const di = (y * cropW + x) * 4;
      croppedBuf[di]     = logoData[si];
      croppedBuf[di + 1] = logoData[si + 1];
      croppedBuf[di + 2] = logoData[si + 2];
      croppedBuf[di + 3] = logoData[si + 3];
    }
  }

  // ── 2. Recolor: green pixels (the D) → white, keep orange crown ──
  for (let i = 0; i < croppedBuf.length; i += 4) {
    const r = croppedBuf[i], g = croppedBuf[i+1], b = croppedBuf[i+2], a = croppedBuf[i+3];
    if (a < 20) continue; // skip transparent
    const isGreen = g > 100 && g > r * 1.1 && r < 180;
    if (isGreen) {
      croppedBuf[i]     = 255; // make white
      croppedBuf[i + 1] = 255;
      croppedBuf[i + 2] = 255;
    }
  }

  // ── 3. Auto-trim transparent border ──
  let minX = cropW, maxX = 0, minY = cropH, maxY = 0;
  for (let y = 0; y < cropH; y++) {
    for (let x = 0; x < cropW; x++) {
      if (croppedBuf[(y * cropW + x) * 4 + 3] > 10) {
        if (x < minX) minX = x;
        if (x > maxX) maxX = x;
        if (y < minY) minY = y;
        if (y > maxY) maxY = y;
      }
    }
  }
  const pad = 4;
  minX = Math.max(0, minX - pad); minY = Math.max(0, minY - pad);
  maxX = Math.min(cropW - 1, maxX + pad); maxY = Math.min(cropH - 1, maxY + pad);
  const trimW = maxX - minX + 1, trimH = maxY - minY + 1;
  const trimBuf = Buffer.alloc(trimW * trimH * 4);
  for (let y = 0; y < trimH; y++) {
    for (let x = 0; x < trimW; x++) {
      const si = ((y + minY) * cropW + (x + minX)) * 4;
      const di = (y * trimW + x) * 4;
      trimBuf[di]     = croppedBuf[si];
      trimBuf[di + 1] = croppedBuf[si + 1];
      trimBuf[di + 2] = croppedBuf[si + 2];
      trimBuf[di + 3] = croppedBuf[si + 3];
    }
  }
  console.log(`Monogram trimmed: ${trimW}x${trimH}`);

  // ── 4. Resize monogram to fit inside circle (72% of icon size) ──
  const monoSize = Math.floor(SIZE * 0.72);
  const monoResized = await sharp(trimBuf, {
    raw: { width: trimW, height: trimH, channels: 4 },
  })
    .resize(monoSize, monoSize, { fit: 'contain', background: { r:0,g:0,b:0,alpha:0 } })
    .png()
    .toBuffer();

  // ── 5. Green circle SVG background ──
  const circleSvg = Buffer.from(
    `<svg width="${SIZE}" height="${SIZE}" xmlns="http://www.w3.org/2000/svg">
      <circle cx="${SIZE/2}" cy="${SIZE/2}" r="${SIZE/2}" fill="#3A7D44"/>
    </svg>`
  );
  const circleBg = await sharp(circleSvg).png().toBuffer();

  // ── 6. Composite monogram centered on circle ──
  const ox = Math.floor((SIZE - monoSize) / 2);
  const oy = Math.floor((SIZE - monoSize) / 2) + 4;
  await sharp(circleBg)
    .composite([{ input: monoResized, left: ox, top: oy }])
    .png()
    .toFile(path.join(OUT, 'dk_app_icon.png'));

  console.log('✓ dk_app_icon.png (D + crown monogram)');
}

main().catch(console.error);

const sharp = require('sharp');
const path = require('path');

const RAW = path.join(__dirname, 'assets', 'raw');
const OUT = path.join(__dirname, 'assets', 'images');

// Auto-trim transparent border from RGBA buffer
function autotrim(data, width, height) {
  let minX = width, maxX = 0, minY = height, maxY = 0;
  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      const a = data[(y * width + x) * 4 + 3];
      if (a > 10) {
        if (x < minX) minX = x;
        if (x > maxX) maxX = x;
        if (y < minY) minY = y;
        if (y > maxY) maxY = y;
      }
    }
  }
  if (minX > maxX || minY > maxY) return { data, width, height }; // all transparent
  const pad = 8;
  minX = Math.max(0, minX - pad);
  minY = Math.max(0, minY - pad);
  maxX = Math.min(width - 1, maxX + pad);
  maxY = Math.min(height - 1, maxY + pad);
  const newW = maxX - minX + 1;
  const newH = maxY - minY + 1;
  const out = Buffer.alloc(newW * newH * 4);
  for (let y = 0; y < newH; y++) {
    for (let x = 0; x < newW; x++) {
      const si = ((y + minY) * width + (x + minX)) * 4;
      const di = (y * newW + x) * 4;
      out[di]     = data[si];
      out[di + 1] = data[si + 1];
      out[di + 2] = data[si + 2];
      out[di + 3] = data[si + 3];
    }
  }
  return { data: out, width: newW, height: newH };
}

async function removeBackground(inputFile, cropBox, keepFn, outputFile) {
  const meta = await sharp(inputFile).metadata();
  const W = meta.width, H = meta.height;
  console.log(`  Source: ${W}x${H}`);

  const { x, y, w, h } = cropBox(W, H);
  console.log(`  Crop: x=${x} y=${y} w=${w} h=${h}`);

  const { data, info } = await sharp(inputFile)
    .extract({ left: x, top: y, width: w, height: h })
    .ensureAlpha()
    .raw()
    .toBuffer({ resolveWithObject: true });

  for (let i = 0; i < data.length; i += 4) {
    const r = data[i], g = data[i+1], b = data[i+2];
    if (!keepFn(r, g, b)) data[i + 3] = 0;
  }

  const { data: td, width: tw, height: th } = autotrim(data, info.width, info.height);
  console.log(`  Trimmed: ${tw}x${th}`);

  await sharp(Buffer.from(td), { raw: { width: tw, height: th, channels: 4 } })
    .png()
    .toFile(outputFile);
  console.log(`  ✓ ${path.basename(outputFile)}`);
}

// ─── 1. dk_crown.png ─ just the orange crown ───────────────────
async function extractCrown() {
  console.log('\n[1] dk_crown.png');
  await removeBackground(
    path.join(RAW, 'logo_full.png.png'),
    (W, H) => ({
      // Crown is above the "D" — upper-left of center
      x: Math.floor(W * 0.24),
      y: Math.floor(H * 0.03),
      w: Math.floor(W * 0.30),
      h: Math.floor(H * 0.52),
    }),
    (r, g, b) => {
      const isOrange = r > 140 && r > g * 1.15 && r > b * 1.7 && b < 140;
      const isGold   = r > 200 && g > 130 && b < 80;
      return isOrange || isGold;
    },
    path.join(OUT, 'dk_crown.png'),
  );
}

// ─── 2. dk_logo.png ─ full DRAFTKINGS logo ─────────────────────
async function extractFullLogo() {
  console.log('\n[2] dk_logo.png');
  await removeBackground(
    path.join(RAW, 'logo_full.png.png'),
    (W, H) => ({
      x: Math.floor(W * 0.14),
      y: Math.floor(H * 0.03),
      w: Math.floor(W * 0.74),
      h: Math.floor(H * 0.70),
    }),
    (r, g, b) => {
      const isOrange = r > 140 && r > g * 1.15 && r > b * 1.7 && b < 140;
      const isGold   = r > 200 && g > 130 && b < 80;
      const isGreen  = g > 100 && g > r * 1.1 && g > b * 0.9 && r < 180;
      const isWhite  = r > 170 && g > 170 && b > 170;
      return isOrange || isGold || isGreen || isWhite;
    },
    path.join(OUT, 'dk_logo.png'),
  );
}

// ─── 3. dk_app_icon.png ─ green DK circle from phone mockup ────
async function extractAppIcon() {
  console.log('\n[3] dk_app_icon.png');
  // First let's see where the icon actually is by checking the image dimensions
  const meta = await sharp(path.join(RAW, 'app_icon_ref.png.jpg')).metadata();
  console.log(`  Full image: ${meta.width}x${meta.height}`);

  await removeBackground(
    path.join(RAW, 'app_icon_ref.png.jpg'),
    (W, H) => ({
      // Green DK icon sits at top-center between/above the two phones
      x: Math.floor(W * 0.33),
      y: Math.floor(H * 0.00),
      w: Math.floor(W * 0.34),
      h: Math.floor(H * 0.30),
    }),
    (r, g, b) => {
      // Green circle bg + white crown inside
      const isGreen  = g > 100 && g > r * 0.85 && g > b * 0.85 && r < 160;
      const isWhite  = r > 160 && g > 160 && b > 160;
      const isDark   = r < 50  && g < 50  && b < 50;
      return !isDark && (isGreen || isWhite);
    },
    path.join(OUT, 'dk_app_icon.png'),
  );
}

(async () => {
  try {
    await extractCrown();
    await extractFullLogo();
    await extractAppIcon();
    console.log('\nAll done!');
  } catch (e) {
    console.error(e.message, e.stack);
  }
})();

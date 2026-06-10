// Build dk_app_icon.png = green circle + white crown (from dk_crown.png recolored)
const sharp = require('sharp');
const path = require('path');
const OUT = path.join(__dirname, 'assets', 'images');

async function main() {
  const SIZE = 200; // final icon size in pixels

  // 1. Load the orange crown, recolor every opaque pixel to white
  const { data: crownData, info } = await sharp(path.join(OUT, 'dk_crown.png'))
    .ensureAlpha()
    .raw()
    .toBuffer({ resolveWithObject: true });

  for (let i = 0; i < crownData.length; i += 4) {
    if (crownData[i + 3] > 10) {         // non-transparent pixel
      crownData[i]     = 255;            // R → white
      crownData[i + 1] = 255;            // G
      crownData[i + 2] = 255;            // B
    }
  }

  const whiteCrown = await sharp(Buffer.from(crownData), {
    raw: { width: info.width, height: info.height, channels: 4 },
  })
    .png()
    .toBuffer();

  // 2. Resize the white crown to fit inside the circle (70% of icon)
  const crownSize = Math.floor(SIZE * 0.70);
  const crownResized = await sharp(whiteCrown)
    .resize(crownSize, crownSize, { fit: 'contain', background: { r: 0, g: 0, b: 0, alpha: 0 } })
    .png()
    .toBuffer();

  // 3. Build green circle background using SVG
  const greenCircleSvg = Buffer.from(
    `<svg width="${SIZE}" height="${SIZE}" xmlns="http://www.w3.org/2000/svg">
      <circle cx="${SIZE / 2}" cy="${SIZE / 2}" r="${SIZE / 2}" fill="#5BD64A"/>
    </svg>`
  );

  const greenCircle = await sharp(greenCircleSvg).png().toBuffer();

  // 4. Composite crown centered on circle
  const offsetX = Math.floor((SIZE - crownSize) / 2);
  const offsetY = Math.floor((SIZE - crownSize) / 2) + Math.floor(SIZE * 0.04); // slightly lower

  const result = await sharp(greenCircle)
    .composite([{ input: crownResized, left: offsetX, top: offsetY }])
    .png()
    .toBuffer();

  await sharp(result).toFile(path.join(OUT, 'dk_app_icon.png'));
  console.log(`✓ dk_app_icon.png created (${SIZE}x${SIZE})`);
}

main().catch(console.error);

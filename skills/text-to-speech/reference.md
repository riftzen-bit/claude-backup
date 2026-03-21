# TTS Provider Reference

Complete API documentation, code examples, and workflows for each provider.

---

## Provider 1: edge-tts (Free, No API Key)

Microsoft Edge's online TTS service. Zero cost, no authentication.

### Install

```bash
pip install edge-tts
```

### CLI Usage

```bash
# List available voices
edge-tts --list-voices

# Generate speech (default voice)
edge-tts --text "Hello world" --write-media output.mp3

# Specific voice + language
edge-tts --voice "en-US-AriaNeural" --text "Hello world" --write-media output.mp3

# Vietnamese voice
edge-tts --voice "vi-VN-HoaiMyNeural" --text "Xin chao" --write-media output.mp3

# Adjust rate and pitch
edge-tts --rate="+20%" --pitch="-10Hz" --text "Faster and deeper" --write-media output.mp3

# Generate subtitles alongside audio
edge-tts --text "Hello world" --write-media output.mp3 --write-subtitles output.vtt
```

### Python Usage

```python
import asyncio
import edge_tts

async def generate_speech(text: str, voice: str = "en-US-AriaNeural", output: str = "output.mp3"):
    communicate = edge_tts.Communicate(text, voice)
    await communicate.save(output)

asyncio.run(generate_speech("Hello, this is a test."))
```

### Batch Processing

```python
import asyncio
import edge_tts
from pathlib import Path

async def batch_tts(texts: list[dict], output_dir: str = "audio"):
    Path(output_dir).mkdir(exist_ok=True)
    for item in texts:
        communicate = edge_tts.Communicate(item["text"], item.get("voice", "en-US-AriaNeural"))
        await communicate.save(f"{output_dir}/{item['filename']}.mp3")

texts = [
    {"text": "Chapter one. The beginning.", "filename": "ch01", "voice": "en-US-GuyNeural"},
    {"text": "Chapter two. The journey.", "filename": "ch02", "voice": "en-US-GuyNeural"},
]
asyncio.run(batch_tts(texts))
```

### Popular Voices

| Voice | Language | Gender | Style |
|-------|----------|--------|-------|
| en-US-AriaNeural | English | Female | Conversational |
| en-US-GuyNeural | English | Male | Narration |
| en-US-JennyNeural | English | Female | Friendly |
| en-GB-SoniaNeural | English (UK) | Female | Professional |
| vi-VN-HoaiMyNeural | Vietnamese | Female | Natural |
| vi-VN-NamMinhNeural | Vietnamese | Male | Natural |
| ja-JP-NanamiNeural | Japanese | Female | Natural |
| zh-CN-XiaoxiaoNeural | Chinese | Female | Conversational |

### Limitations

- Relies on Microsoft's cloud service — may rate-limit heavy usage
- No voice cloning
- No SSML fine-tuning beyond rate/pitch/volume
- Quality below ElevenLabs for expressive speech

---

## Provider 2: ElevenLabs (Best Quality)

Premium TTS with emotional expressiveness, voice cloning, and 70+ languages.

### Setup

```bash
pip install elevenlabs
export ELEVENLABS_API_KEY="your-key-here"
```

### Models

| Model | Latency | Best For |
|-------|---------|----------|
| `eleven_flash_v2_5` | ~75ms | Real-time, streaming, low latency |
| `eleven_turbo_v2_5` | ~250ms | Balanced quality and speed |
| `eleven_multilingual_v2` | ~300ms | Long-form, multilingual content |
| `eleven_v3` | ~300ms | Maximum expressiveness, emotion |

### Python SDK

```python
from elevenlabs.client import ElevenLabs
import os

client = ElevenLabs(api_key=os.environ["ELEVENLABS_API_KEY"])

audio = client.text_to_speech.convert(
    text="Welcome to the future of voice synthesis.",
    voice_id="JBFqnCBsd6RMkjVDRZzb",  # George
    model_id="eleven_v3",
    output_format="mp3_44100_128"
)

with open("output.mp3", "wb") as f:
    for chunk in audio:
        f.write(chunk)
```

### HTTP API (No SDK)

```python
import os, requests

voice_id = "JBFqnCBsd6RMkjVDRZzb"
resp = requests.post(
    f"https://api.elevenlabs.io/v1/text-to-speech/{voice_id}",
    headers={"xi-api-key": os.environ["ELEVENLABS_API_KEY"], "Content-Type": "application/json"},
    json={
        "text": "Your text here",
        "model_id": "eleven_v3",
        "voice_settings": {"stability": 0.5, "similarity_boost": 0.75, "style": 0.5, "use_speaker_boost": True}
    }
)
with open("output.mp3", "wb") as f:
    f.write(resp.content)
```

### Voice Cloning

```python
voice = client.clone(name="My Voice", files=["sample.mp3"], description="My custom cloned voice")
audio = client.text_to_speech.convert(text="Speaking with my cloned voice.", voice_id=voice.voice_id, model_id="eleven_multilingual_v2")
```

### Streaming

```python
audio_stream = client.text_to_speech.convert_as_stream(
    text="This streams chunk by chunk for real-time playback.",
    voice_id="JBFqnCBsd6RMkjVDRZzb",
    model_id="eleven_flash_v2_5"
)
with open("stream_output.mp3", "wb") as f:
    for chunk in audio_stream:
        f.write(chunk)
```

### Voice Settings

| Parameter | Range | Effect |
|-----------|-------|--------|
| `stability` | 0.0-1.0 | Lower = more expressive, higher = more consistent |
| `similarity_boost` | 0.0-1.0 | Higher = closer to original voice |
| `style` | 0.0-1.0 | Higher = more stylistic variation (v2+ only) |
| `use_speaker_boost` | bool | Enhances voice clarity |

---

## Provider 3: OpenAI TTS

Simple API, good quality, integrates with OpenAI ecosystem.

### Setup

```bash
pip install openai
export OPENAI_API_KEY="your-key-here"
```

### Usage

```python
from openai import OpenAI
import os

client = OpenAI(api_key=os.environ["OPENAI_API_KEY"])
response = client.audio.speech.create(
    model="tts-1-hd",  # or "tts-1" for faster/cheaper
    voice="nova",       # alloy, echo, fable, onyx, nova, shimmer
    input="The quick brown fox jumps over the lazy dog.",
    response_format="mp3"
)
response.stream_to_file("output.mp3")
```

### Voices

| Voice | Style |
|-------|-------|
| alloy | Neutral, balanced |
| echo | Warm, grounded |
| fable | Expressive, storytelling |
| onyx | Deep, authoritative |
| nova | Friendly, conversational |
| shimmer | Soft, gentle |

### Models

| Model | Quality | Latency | Cost |
|-------|---------|---------|------|
| `tts-1` | Good | Low | $15/1M chars |
| `tts-1-hd` | Better | Higher | $30/1M chars |

---

## Provider 4: Google Cloud TTS

380+ voices, 50+ languages, enterprise-grade.

### Setup

```bash
pip install google-cloud-texttospeech
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"
```

### Usage

```python
from google.cloud import texttospeech

client = texttospeech.TextToSpeechClient()
input_text = texttospeech.SynthesisInput(text="Hello from Google Cloud.")
voice = texttospeech.VoiceSelectionParams(language_code="en-US", name="en-US-Studio-O", ssml_gender=texttospeech.SsmlVoiceGender.FEMALE)
audio_config = texttospeech.AudioConfig(audio_encoding=texttospeech.AudioEncoding.MP3)
response = client.synthesize_speech(input=input_text, voice=voice, audio_config=audio_config)

with open("output.mp3", "wb") as f:
    f.write(response.audio_content)
```

### Voice Tiers

| Tier | Quality | Cost/1M chars |
|------|---------|---------------|
| Standard | Basic | $4 |
| WaveNet | Neural | $16 |
| Neural2 | Improved neural | $16 |
| Studio | Highest quality | $160 |
| Chirp 3 | Latest, voice cloning | Varies |

---

## Provider 5: fal.ai CSM-1B

Conversational speech model via fal.ai. Good for natural dialogue.

### Usage (requires fal.ai MCP)

```
generate(model_name: "fal-ai/csm-1b", input: {"text": "Hello, welcome.", "speaker_id": 0})
```

---

## Common Workflows

### Document to Audiobook

```python
import asyncio, edge_tts
from pathlib import Path

async def document_to_audiobook(text_file: str, voice: str = "en-US-GuyNeural"):
    text = Path(text_file).read_text()
    chapters = text.split("\n\n")
    for i, chapter in enumerate(chapters):
        if chapter.strip():
            communicate = edge_tts.Communicate(chapter.strip(), voice)
            await communicate.save(f"audiobook_ch{i:03d}.mp3")

asyncio.run(document_to_audiobook("book.txt"))
```

Concatenate: `for f in audiobook_ch*.mp3; do echo "file '$f'"; done > concat.txt && ffmpeg -f concat -safe 0 -i concat.txt -c copy audiobook_full.mp3`

### Multilingual Voiceover

```python
import asyncio, edge_tts

scripts = [
    {"text": "Welcome to our product demo.", "voice": "en-US-AriaNeural", "file": "en.mp3"},
    {"text": "Chao mung den voi san pham.", "voice": "vi-VN-HoaiMyNeural", "file": "vi.mp3"},
    {"text": "Bienvenue a notre demo.", "voice": "fr-FR-DeniseNeural", "file": "fr.mp3"},
]

async def multilingual():
    for s in scripts:
        await edge_tts.Communicate(s["text"], s["voice"]).save(s["file"])

asyncio.run(multilingual())
```

### Video Narration

```bash
# Add voiceover to video
ffmpeg -i video.mp4 -i voiceover.mp3 -c:v copy -map 0:v:0 -map 1:a:0 output.mp4

# Mix voiceover with existing audio (50% original volume)
ffmpeg -i video.mp4 -i voiceover.mp3 -filter_complex "[0:a]volume=0.5[bg];[bg][1:a]amix=inputs=2:duration=longest" -c:v copy mixed.mp4
```

## Error Handling

| Error | Cause | Fix |
|-------|-------|-----|
| `edge_tts` timeout | Microsoft rate limit | Add delay, reduce batch size |
| ElevenLabs 401 | Invalid API key | Check `ELEVENLABS_API_KEY` |
| ElevenLabs 429 | Rate limit / quota | Upgrade plan or retry with backoff |
| OpenAI 400 | Text >4096 chars | Split into chunks |
| Google 403 | Permissions | Enable Cloud TTS API in Console |

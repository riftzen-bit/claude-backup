---
name: text-to-speech
description: Generate speech audio from text using multiple TTS providers — ElevenLabs, OpenAI, Google Cloud, fal.ai CSM-1B, and edge-tts (free). Smart-routes by quality, cost, and latency requirements. Use when user says "text to speech", "TTS", "generate voice", "voiceover", "narration", "read aloud", "convert text to audio", or "speech synthesis".
---

# Text-to-Speech

Smart-routed speech synthesis across multiple providers. Pick the right engine for the job.

## When to Activate

- User wants to convert text to speech audio
- Generating voiceover or narration for video/podcast
- Batch converting documents to audio
- Voice cloning or custom voice creation
- Multilingual speech synthesis
- Real-time or streaming TTS
- User says "TTS", "text to speech", "voiceover", "narrate", "read aloud", "generate voice"

## Do NOT Use For

- Speech-to-text / transcription (use Whisper or Deepgram)
- Music generation (use `fal-ai-media` skill)
- Sound effects (use `fal-ai-media` ThinkSound)
- Full video editing pipeline (use `video-editing` skill)

## Provider Routing

Pick provider based on the use case:

| Need | Provider | Cost | Latency | Quality |
|------|----------|------|---------|---------|
| Free / prototyping / batch | **edge-tts** | Free | ~200ms | Good |
| Best quality / emotion | **ElevenLabs** | $$$ | ~75-300ms | Excellent |
| OpenAI ecosystem | **OpenAI TTS** | $$ | ~300ms | Very Good |
| Multilingual / enterprise | **Google Cloud TTS** | $ | ~100ms | Very Good |
| fal.ai ecosystem | **fal.ai CSM-1B** | $ | ~500ms | Good |

### Decision Flow

```
Is this a prototype or personal use?
  YES → edge-tts (free, no API key)
  NO →
    Need best emotional expressiveness?
      YES → ElevenLabs (Eleven v3)
      NO →
        Already using OpenAI APIs?
          YES → OpenAI TTS
          NO →
            Need 50+ languages or enterprise SLA?
              YES → Google Cloud TTS
              NO →
                fal.ai MCP configured?
                  YES → fal.ai CSM-1B
                  NO → edge-tts
```

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
# Set API key
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

# Basic generation
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
import os
import requests

voice_id = "JBFqnCBsd6RMkjVDRZzb"
resp = requests.post(
    f"https://api.elevenlabs.io/v1/text-to-speech/{voice_id}",
    headers={
        "xi-api-key": os.environ["ELEVENLABS_API_KEY"],
        "Content-Type": "application/json"
    },
    json={
        "text": "Your text here",
        "model_id": "eleven_v3",
        "voice_settings": {
            "stability": 0.5,
            "similarity_boost": 0.75,
            "style": 0.5,
            "use_speaker_boost": True
        }
    }
)
with open("output.mp3", "wb") as f:
    f.write(resp.content)
```

### Voice Cloning

```python
# Instant clone (few seconds of audio)
voice = client.clone(
    name="My Voice",
    files=["sample.mp3"],
    description="My custom cloned voice"
)

audio = client.text_to_speech.convert(
    text="Speaking with my cloned voice.",
    voice_id=voice.voice_id,
    model_id="eleven_multilingual_v2"  # PVC not yet optimized for v3
)
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

### Voice Settings Guide

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
    response_format="mp3"  # mp3, opus, aac, flac, wav, pcm
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

voice = texttospeech.VoiceSelectionParams(
    language_code="en-US",
    name="en-US-Studio-O",  # Studio voices are highest quality
    ssml_gender=texttospeech.SsmlVoiceGender.FEMALE
)

audio_config = texttospeech.AudioConfig(
    audio_encoding=texttospeech.AudioEncoding.MP3,
    speaking_rate=1.0,
    pitch=0.0
)

response = client.synthesize_speech(
    input=input_text, voice=voice, audio_config=audio_config
)

with open("output.mp3", "wb") as f:
    f.write(response.audio_content)
```

### SSML Support

```python
ssml_text = texttospeech.SynthesisInput(ssml="""
<speak>
  <prosody rate="slow" pitch="-2st">
    This is spoken slowly with a lower pitch.
  </prosody>
  <break time="500ms"/>
  <emphasis level="strong">This part is emphasized.</emphasis>
</speak>
""")
```

### Voice Tiers

| Tier | Quality | Cost/1M chars |
|------|---------|---------------|
| Standard | Basic | $4 |
| WaveNet | Neural | $16 |
| Neural2 | Improved neural | $16 |
| Studio | Highest quality | $160 |
| Chirp 3 | Latest, voice cloning | Varies |

### Instant Voice Clone (Chirp 3)

Requires only 10 seconds of sample audio:

```python
# Upload reference audio, then use the cloned voice
# See Google Cloud docs for Chirp 3 voice cloning API
```

---

## Provider 5: fal.ai CSM-1B

Conversational speech model via fal.ai MCP. Good for natural dialogue.

### Prerequisite

fal.ai MCP must be configured (see `fal-ai-media` skill).

### Usage

```
generate(
  model_name: "fal-ai/csm-1b",
  input: {
    "text": "Hello, welcome to the demo. Let me show you how this works.",
    "speaker_id": 0
  }
)
```

---

## Common Workflows

### Workflow 1: Document to Audiobook

```python
import asyncio
import edge_tts
from pathlib import Path

async def document_to_audiobook(text_file: str, voice: str = "en-US-GuyNeural"):
    text = Path(text_file).read_text()

    # Split into chapters or paragraphs
    chapters = text.split("\n\n")

    for i, chapter in enumerate(chapters):
        if chapter.strip():
            communicate = edge_tts.Communicate(chapter.strip(), voice)
            await communicate.save(f"audiobook_ch{i:03d}.mp3")

asyncio.run(document_to_audiobook("book.txt"))
```

Then concatenate with FFmpeg:

```bash
for f in audiobook_ch*.mp3; do echo "file '$f'"; done > concat.txt
ffmpeg -f concat -safe 0 -i concat.txt -c copy audiobook_full.mp3
```

### Workflow 2: Multilingual Voiceover

```python
import asyncio
import edge_tts

scripts = [
    {"text": "Welcome to our product demo.", "voice": "en-US-AriaNeural", "file": "en.mp3"},
    {"text": "Chao mung den voi san pham.", "voice": "vi-VN-HoaiMyNeural", "file": "vi.mp3"},
    {"text": "Bienvenue a notre demo.", "voice": "fr-FR-DeniseNeural", "file": "fr.mp3"},
]

async def multilingual():
    for s in scripts:
        communicate = edge_tts.Communicate(s["text"], s["voice"])
        await communicate.save(s["file"])

asyncio.run(multilingual())
```

### Workflow 3: Video Narration Pipeline

1. Write script
2. Generate voice with ElevenLabs (quality) or edge-tts (free)
3. Mix with video using FFmpeg:

```bash
# Add voiceover to video
ffmpeg -i video.mp4 -i voiceover.mp3 -c:v copy -map 0:v:0 -map 1:a:0 output.mp4

# Mix voiceover with existing audio (50% original volume)
ffmpeg -i video.mp4 -i voiceover.mp3 -filter_complex "[0:a]volume=0.5[bg];[bg][1:a]amix=inputs=2:duration=longest" -c:v copy mixed.mp4
```

## Cost Comparison

| Provider | Free Tier | Paid Rate | Best Value For |
|----------|-----------|-----------|----------------|
| edge-tts | Unlimited* | Free | Prototyping, personal, batch |
| ElevenLabs | 10K chars/mo | ~$0.30/1K chars | Premium content, voice cloning |
| OpenAI | None | $15-30/1M chars | OpenAI ecosystem users |
| Google Cloud | 1M chars/mo (Standard) | $4-160/1M chars | Enterprise, multilingual |
| fal.ai CSM-1B | Credits-based | ~$0.01/request | fal.ai ecosystem users |

*edge-tts may rate-limit under heavy usage

## Error Handling

| Error | Cause | Fix |
|-------|-------|-----|
| `edge_tts` timeout | Microsoft service rate limit | Add delay between requests, reduce batch size |
| ElevenLabs 401 | Invalid API key | Check `ELEVENLABS_API_KEY` env var |
| ElevenLabs 429 | Rate limit / quota exceeded | Upgrade plan or add retry with backoff |
| OpenAI 400 | Text too long (>4096 chars) | Split text into chunks |
| Google 403 | Service account permissions | Enable Cloud TTS API in Google Console |

## Tips

1. **Start free**: Use edge-tts for prototyping, switch to paid for production
2. **Chunk long text**: Most APIs have per-request character limits (1K-5K). Split text at sentence boundaries
3. **Cache results**: TTS output is deterministic per input — cache audio files to avoid re-generating
4. **Normalize audio**: Run `ffmpeg -af loudnorm` on output for consistent volume levels
5. **Match voice to content**: Narration needs stability (0.7+), dialogue needs expressiveness (0.3-0.5)

## Related Skills

- `fal-ai-media` — AI media generation including CSM-1B TTS
- `video-editing` — Full video editing pipeline with voiceover integration
- `content-engine` — Content creation with audio components

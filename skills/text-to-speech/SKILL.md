---
name: text-to-speech
description: Generate speech audio from text using multiple TTS providers — ElevenLabs, OpenAI, Google Cloud, fal.ai CSM-1B, and edge-tts (free). Smart-routes by quality, cost, and latency requirements. Use when user says "text to speech", "TTS", "generate voice", "voiceover", "narration", "read aloud", "convert text to audio", or "speech synthesis".
---

# Text-to-Speech

Smart-routed speech synthesis across multiple providers. See `reference.md` in this directory for full provider APIs, code examples, and workflows.

## When to Activate

- User wants to convert text to speech audio
- Generating voiceover or narration for video/podcast
- Batch converting documents to audio
- Voice cloning or custom voice creation
- Multilingual speech synthesis
- Real-time or streaming TTS

## Do NOT Use For

- Speech-to-text / transcription (use Whisper or Deepgram)
- Music or sound effects generation

## Provider Routing

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
              NO → edge-tts
```

## Cost Comparison

| Provider | Free Tier | Paid Rate | Best Value For |
|----------|-----------|-----------|----------------|
| edge-tts | Unlimited* | Free | Prototyping, personal, batch |
| ElevenLabs | 10K chars/mo | ~$0.30/1K chars | Premium content, voice cloning |
| OpenAI | None | $15-30/1M chars | OpenAI ecosystem users |
| Google Cloud | 1M chars/mo (Standard) | $4-160/1M chars | Enterprise, multilingual |
| fal.ai CSM-1B | Credits-based | ~$0.01/request | fal.ai ecosystem users |

## Tips

1. **Start free**: Use edge-tts for prototyping, switch to paid for production
2. **Chunk long text**: Most APIs limit 1K-5K chars per request. Split at sentence boundaries
3. **Cache results**: TTS output is deterministic — cache to avoid re-generating
4. **Normalize audio**: `ffmpeg -af loudnorm` for consistent volume
5. **Match voice to content**: Narration → stability 0.7+, dialogue → expressiveness 0.3-0.5

For full provider setup, code examples, voice lists, and workflows, read `reference.md`.

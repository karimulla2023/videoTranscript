import gradio as gr
import whisper
import tempfile
import subprocess
import os

model = whisper.load_model("tiny.en")

def transcribe_video(video_file):
    # Save video locally
    path = tempfile.mktemp(suffix=".mp4")
    with open(path, "wb") as f:
        f.write(video_file.read())

    # Extract audio
    audio_path = tempfile.mktemp(suffix=".wav")
    subprocess.run([
        "ffmpeg", "-y", "-i", path,
        "-vn", "-ac", "1", "-ar", "16000", audio_path
    ], check=True)

    # Transcribe
    res = model.transcribe(audio_path, fp16=False)
    # Cleanup
    os.remove(path); os.remove(audio_path)
    return res["text"]

demo = gr.Interface(
    fn=transcribe_video,
    inputs=gr.File(label="Upload video"),
    outputs=gr.Textbox(label="Transcript"),
    title="Video Transcription with Whisper"
)

demo.launch()

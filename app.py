# app.py
import streamlit as st
import whisper
import tempfile

st.set_page_config(page_title="Video Transcriber", layout="centered")

st.title("🎙️ Video Transcription App")
uploaded_file = st.file_uploader("Upload a video file (MP4, MOV, etc.)", type=["mp4", "mov", "mkv", "webm"])

if uploaded_file is not None:
    with tempfile.NamedTemporaryFile(delete=False, suffix=".mp4") as tmp_file:
        tmp_file.write(uploaded_file.read())
        tmp_file_path = tmp_file.name

    st.write("Transcribing...")
    model = whisper.load_model("base")  # You can also use 'tiny', 'small'
    result = model.transcribe(tmp_file_path)
    st.text_area("Transcription Result", result["text"], height=300)

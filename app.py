import streamlit as st
import whisper
import tempfile
import os

# Load the lightweight Whisper model
@st.cache_resource
def load_model():
    return whisper.load_model("tiny")

model = load_model()

st.title("Video Transcription App")
st.write("Upload a video file to get a transcript.")

uploaded_file = st.file_uploader("Choose a video...", type=["mp4", "mov", "avi", "mkv"])

if uploaded_file is not None:
    st.video(uploaded_file)

    with tempfile.NamedTemporaryFile(delete=False, suffix=".mp4") as temp_video:
        temp_video.write(uploaded_file.read())
        temp_path = temp_video.name

    st.write("Transcribing...")
    result = model.transcribe(temp_path)
    st.success("Done!")

    st.subheader("Transcript:")
    st.text(result["text"])

    os.remove(temp_path)

import Image from "next/image";

// import homePic from '../../../public/home.png'

export default async function About() {

  const response = await fetch("https://api.adviceslip.com/advice");
  const data = await response.json();

  return (
    <main>
      <h1>About Page</h1>
      <p>{data.slip.advice}</p>
      <Image
      src={'/home.png'} // Replace with your image filename
      alt="Description of your image"
      width={300} // Optional: Set image width
      height={300} // Optional: Set image height
    />
    </main>
  );
}

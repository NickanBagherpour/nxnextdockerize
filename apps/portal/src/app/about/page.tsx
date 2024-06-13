export default async function About() {

  const response = await fetch("https://api.adviceslip.com/advice");
  const data = await response.json();

  return (
    <main>
      <h1>About Page</h1>
      <p>{data.slip.advice}</p>
    </main>
  );
}

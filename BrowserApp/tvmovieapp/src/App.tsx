import { BrowserRouter, Routes, Route } from "react-router-dom";
import HomePageView from "./pages/homePageView/page";
import ListView from "./pages/listView/ListView";

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<HomePageView />} />
        <Route path="/explore" element={<ListView />} />
      </Routes>
    </BrowserRouter>
  );
}


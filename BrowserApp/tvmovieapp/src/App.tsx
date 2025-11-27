import { BrowserRouter, Routes, Route } from "react-router-dom";
import HomePageView from "./pages/homePageView/page";
import ListView from "./pages/listView/ListView";
import { DetailsView } from "./pages/detailsView/DetailsView";

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<HomePageView />} />
        <Route path="/explore" element={<ListView />} />
        <Route path="/movie/*" element={<DetailsView />} />
      </Routes>
    </BrowserRouter>
  );
}

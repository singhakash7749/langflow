import { useState } from "react";
import Markdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { CustomLink } from "@/customization/components/custom-link";
import IconComponent from "../../../../components/common/genericIconComponent";
import type { SingleAlertComponentType } from "../../../../types/alerts";

export default function SingleAlert({
  dropItem,
  removeAlert,
}: SingleAlertComponentType): JSX.Element {
  const [_show, setShow] = useState(true);
  const type = dropItem.type;

  return type === "error" ? (
    <div
      className="mx-2 mb-2 flex rounded-md bg-error-background p-3"
      key={dropItem.id}
    >
      <div className="flex-shrink-0">
        <IconComponent name="XCircle" className="h-5 w-5 text-status-red" />
      </div>
      <div className="ml-3">
        <h3 className="text-sm font-medium text-error-foreground word-break-break-word">
          {dropItem.title}
        </h3>
        {dropItem.list ? (
          <div className="mt-2 text-sm text-error-foreground">
            <ul className="list-disc space-y-1 pl-5 align-top">
              {dropItem.list.map((item, idx) => (
                <li className="word-break-break-word" key={idx}>
                  <Markdown
                    linkTarget="_blank"
                    remarkPlugins={[remarkGfm]}
                    className="align-text-top"
                    components={{
                      a: ({ node, ...props }) => (
                        <a
                          href={props.href}
                          target="_blank"
                          className="underline"
                          rel="noopener noreferrer"
                        >
                          {props.children}
                        </a>
                      ),
                      p({ node, ...props }) {
                        return (
                          <span className="inline-block w-fit max-w-full align-text-top">
                            {props.children}
                          </span>
                        );
                      },
                    }}
                  >
                    {Array.isArray(item) ? item.join("\n") : item}
                  </Markdown>
                </li>
              ))}
            </ul>
          </div>
        ) : (
          <></>
        )}
      </div>
      <div className="ml-auto pl-3">
        <div className="-mx-1.5 -my-1.5">
          <button
            type="button"
            onClick={() => {
              setShow(false);
              setTimeout(() => {
                removeAlert(dropItem.id);
              }, 500);
            }}
            className="inline-flex rounded-md p-1.5 text-status-red"
          >
            <span className="sr-only">Dismiss</span>
            <IconComponent name="X" className="h-4 w-4 text-error-foreground" />
          </button>
        </div>
      </div>
    </div>
  ) : type === "notice" ? (
    <div
      className="mx-2 mb-2 flex rounded-md bg-info-background p-3"
      key={dropItem.id}
    >
      <div className="flex-shrink-0 cursor-help">
        <IconComponent name="Info" className="h-5 w-5 text-status-blue" />
      </div>
      <div className="ml-3 flex-1 md:flex md:justify-between">
        <p className="text-sm font-medium text-info-foreground">
          {dropItem.title}
        </p>
        <p className="mt-3 text-sm md:ml-6 md:mt-0">
          {dropItem.link ? (
            <CustomLink
              to={dropItem.link}
              className="whitespace-nowrap font-medium text-info-foreground hover:text-accent-foreground"
            >
              Details
            </CustomLink>
          ) : (
            <></>
          )}
        </p>
      </div>
      <div className="ml-auto pl-3">
        <div className="-mx-1.5 -my-1.5">
          <button
            type="button"
            onClick={() => {
              setShow(false);
              setTimeout(() => {
                removeAlert(dropItem.id);
              }, 500);
            }}
            className="inline-flex rounded-md p-1.5 text-info-foreground"
          >
            <span className="sr-only">Dismiss</span>
            <IconComponent name="X" className="h-4 w-4 text-info-foreground" />
          </button>
        </div>
      </div>
    </div>
  ) : (
    <div
      className="mx-2 mb-2 flex rounded-md bg-success-background p-3"
      key={dropItem.id}
    >
      <div className="flex-shrink-0">
        <IconComponent
          name="CheckCircle2"
          className="h-5 w-5 text-status-green"
        />
      </div>
      <div className="ml-3">
        <p className="text-sm font-medium text-success-foreground">
          {dropItem.title}
        </p>
      </div>
      <div className="ml-auto pl-3">
        <div className="-mx-1.5 -my-1.5">
          <button
            type="button"
            onClick={() => {
              setShow(false);
              setTimeout(() => {
                removeAlert(dropItem.id);
              }, 500);
            }}
            className="inline-flex rounded-md p-1.5 text-status-green"
          >
            <span className="sr-only">Dismiss</span>
            <IconComponent
              name="X"
              className="h-4 w-4 text-success-foreground"
            />
          </button>
        </div>
      </div>
    </div>
  );
}
